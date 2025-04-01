## A node responsible for spawning instances of a given scene at random positions within a defined shape.
@tool
class_name Spawner
extends Node2D

## The scene to be instantiated and spawned.
@export var scene: PackedScene

## The shape within which the instances will be spawned.
@export var shape: Shape

## The maximum number of instances that can be spawned at the same time.
## If negative, there is no limit.
@export var max_count: int = -1

var _timer: Timer
var _target_spawned_count: int = 0
var _counter: int = 0
var _current_spawned_count: int = 0
var _max_spawned_count: int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_timer = Timer.new()
	add_child(_timer)
	_timer.timeout.connect(_spawn, CONNECT_DEFERRED)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()


# Draws the shape in the editor for visual feedback.
func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	if shape == null:
		return
	shape.draw(self)


## Starts the spawning process with a specified interval and count.
## @param spawn_interval: Time in seconds between each spawn. If less than 0.05, spawns all at once.
## @param spawn_count: Number of instances to spawn. If negative, spawns indefinitely.
## Note: If spawn_interval is less than 0.05, spawn_count should be positive to avoid invalid state.
func start_spawning(spawn_interval: float = 1, spawn_count: int = -1) -> void:
	if spawn_interval < 0.05 and spawn_count <= 0 or spawn_count == 0:
		push_error("INVALID INPUTS: spawn_interval: %s, spawn_count: %s" % [spawn_interval, spawn_count])
		return

	_timer.wait_time = spawn_interval
	_timer.one_shot = false
	_target_spawned_count = spawn_count
	_counter = 0
	_max_spawned_count = max_count

	if spawn_interval < 0.05:
		_spawn.call_deferred(spawn_count)
	else:
		_timer.start()


func stop_spawning() -> void:
	_timer.stop()


func _spawn(count: int = 1) -> void:
	if _max_spawned_count >= 0 and _current_spawned_count >= _max_spawned_count:
		return

	for i in count:
		var instance: Node2D = scene.instantiate()
		add_child(instance)
		instance.tree_exited.connect(_on_spawned_exited, CONNECT_ONE_SHOT)
		instance.position = shape.random_point()

		_current_spawned_count += 1
		if _target_spawned_count > 0 and _counter >= _target_spawned_count:
			stop_spawning()
			break


func _on_spawned_exited() -> void:
	_current_spawned_count -= 1

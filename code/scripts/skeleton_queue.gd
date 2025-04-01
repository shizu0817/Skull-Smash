class_name SkeletonQueue
extends Node2D


@export_range(0, 20) var size: int = 5
@export var skeleton_spawner: SkeletonSpawner

@export_group("arrangement")
@export var distance_between_skeletons: float

var _queue: Array[Skeleton]


func _ready() -> void:
	_queue = []
	for i in range(size):
		_add_new_skeleton()


func front() -> Skeleton:
	var skeleton: Skeleton = _queue.front()
	return skeleton


func stop_spawning() -> void:
	for skeleton in _queue:
		skeleton.killed.disconnect(_on_skeleton_killed)


func _add_new_skeleton() -> void:
	var skeleton: Skeleton = skeleton_spawner.spawn()
	_queue.append(skeleton)
	add_child(skeleton)
	skeleton.global_position = global_position + \
		Vector2.RIGHT * distance_between_skeletons * (_queue.size() - 1)

	skeleton.killed.connect(_on_skeleton_killed, CONNECT_ONE_SHOT)


func _on_skeleton_killed(killed_skeleton: Skeleton) -> void:
	var index: int = _queue.find(killed_skeleton)
	if index == -1:
		return

	_queue.remove_at(index)
	_add_new_skeleton()

	for i in range(index, _queue.size()):
		var skeleton: Skeleton = _queue[i]
		var target_position: Vector2 = global_position + \
									   Vector2.RIGHT * distance_between_skeletons * i
		skeleton.move_to(target_position)

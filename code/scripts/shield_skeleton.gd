class_name ShieldSkeleton
extends Skeleton


@export var animated_sprite: AnimatedSprite2D
@export var timer: Timer
@export var idle_time: float
@export var guard_time: float
@export var guard_feel: FeelPlayer

var _is_guarding: bool


func _ready() -> void:
	timer.timeout.connect(_switch_state)
	if randf() >= 0.5:
		_start_idle()
	else:
		_start_guard()


func take_attack(player: Player, direction: Vector2) -> void:
	if not player.stats.can_break_shield and _is_guarding:
		guard_feel.play()
		_start_guard()
		return

	super.take_attack(player, direction)


func _switch_state() -> void:
	if _is_guarding:
		_start_idle()
	else:
		_start_guard()


func _start_guard() -> void:
	timer.start(guard_time)
	_is_guarding = true
	animated_sprite.play("Guard")


func _start_idle() -> void:
	timer.start(idle_time)
	_is_guarding = false
	animated_sprite.play("Idle")

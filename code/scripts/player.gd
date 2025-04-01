class_name Player
extends Node2D


static var Instance: Player

signal level_up(level: int)
signal charge_ratio_changed(player_position:Vector2, ratio: float)
signal charge_attacked

@export var skeleton_queue: SkeletonQueue
@export var animated_sprite: AnimatedSprite2D
@export var stats_retriever: PlayerStatsRetriever
@export var aim_system: AimSystem
@export var experience_view: ExperienceView
@export var attack_feel: FeelPlayer

@export_group("charge mode")
@export var max_charge_time: float = 5
@export var decrease_multiplier: float = 3
@export var charging_particle: GPUParticles2D

var stats: PlayerStats
var is_attacking: bool = false
var is_charging: bool = false
var is_fully_charged: bool:
	get:
		return _charge_time >= max_charge_time

var _experience: int = 0
var _controller: PlayerController
var _charge_time: float = 0


func _unhandled_input(event: InputEvent) -> void:
	if _controller == null:
		return

	_controller.handle_input(event)


func _init() -> void:
	Instance = self


func _ready() -> void:
	stats = stats_retriever.get_initial_stats()
	aim_system.change_hint_length(stats.aim_hint_length)
	animated_sprite.animation_finished.connect(animated_sprite.play.bind("Idle"))


func _process(delta: float) -> void:
	if not stats.is_charge_mode:
		return

	if is_charging:
		_charge_time += delta
	else:
		_charge_time -= delta * decrease_multiplier

	_charge_time = clampf(_charge_time, 0, max_charge_time)
	var charge_ratio: float = _charge_time / max_charge_time
	charge_ratio_changed.emit(global_position, charge_ratio)
	charging_particle.amount_ratio = charge_ratio


func enable_controller() -> void:
	_controller = PlayerController.new(self)
	animated_sprite.animation_finished.disconnect(animated_sprite.play)
	animated_sprite.animation_finished.connect(_controller._on_attack_ended)


func disable_controller() -> void:
	animated_sprite.animation_finished.disconnect(_controller._on_attack_ended)
	animated_sprite.animation_finished.connect(animated_sprite.play.bind("Idle"))
	_controller = null


func attack() -> void:
	animated_sprite.play("Attack")
	is_attacking = true

	var skeleton: Skeleton = skeleton_queue.front()

	if not stats.is_charge_mode:
		skeleton.take_attack(self, aim_system.get_direction())
	else:
		skeleton.take_attack(self, Vector2.from_angle(deg_to_rad(-75)))
		charging_particle.emitting = false
		charge_attacked.emit()

	attack_feel.play()


func idle() -> void:
	animated_sprite.play("Idle")
	is_attacking = false


func earn_experience(experience: int) -> void:
	_experience += experience
	if _experience >= stats.max_experience:
		_level_up()

	experience_view.increase_to(float(_experience) / stats.max_experience)


func lost_experience(experience: int) -> void:
	_experience -= experience
	_experience = max(0, _experience)

	experience_view.decrease_to(float(_experience) / stats.max_experience)


func _level_up() -> void:
	_experience -= stats.max_experience

	var next_level: int = stats.level + 1
	stats = stats_retriever.get_stats(next_level)
	aim_system.change_hint_length(stats.aim_hint_length)

	if stats.is_charge_mode:
		charging_particle.emitting = true

	level_up.emit(stats.level)

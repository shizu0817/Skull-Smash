class_name GameManager
extends Node

@export_group("skeleton and shield skeleton")
@export var skeleton_spawner: SkeletonSpawner
@export var skeleton_queue: SkeletonQueue
@export var level_to_spawn_shield_skeleton: int

@export_group("wizard skeleton")
@export var wizard_skeleton_spawner: Spawner
@export var spawn_intervals: Array[float]
@export var max_counts: Array[int]

@export_group("ball")
@export var ball: Ball
@export var start_feel: FeelPlayer

@export_group("tooltips")
@export var typewriter: Typewriter
@export var tooltips: Array[TooltipData]

@export_group("exp bar")
@export var experience_view: ExperienceView

@export_group("end game")
@export var end_level: int = 0
@export var end_feel: FeelPlayer
@export var restart_typewriter: Typewriter
@export var fireworks_spawner: Spawner

@export_group("camera")
@export var cameraController: CameraController


var _game_started: bool = false
var _is_ended: bool = false
var _player_first_time_fully_charged: bool = true


func _ready() -> void:
	Player.Instance.level_up.connect(_on_player_level_up)
	Player.Instance.charge_attacked.connect(_on_player_charge_attacked)
	ball.broke.connect(_end_game, CONNECT_ONE_SHOT)


func _unhandled_input(event: InputEvent) -> void:
	if not _game_started and event.is_action_pressed("attack"):
		_start_game()
	elif _is_ended and event.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _on_player_level_up(player_level: int) -> void:
	if player_level < 0 or player_level >= spawn_intervals.size():
		return

	if max_counts[player_level] != 0:
		wizard_skeleton_spawner.max_count = max_counts[player_level]
		wizard_skeleton_spawner.start_spawning(spawn_intervals[player_level], -1)
	else:
		wizard_skeleton_spawner.stop_spawning()

	if player_level == level_to_spawn_shield_skeleton:
		skeleton_spawner.start_spawning_skeleton_with_shield()

	if player_level == end_level:
		_start_ending()

	_update_tooltip(player_level)


func _on_player_charge_attacked() -> void:
	typewriter.label.text = ""


func _start_game() -> void:
	_game_started = true
	Player.Instance.animated_sprite.play("Attack")
	Player.Instance.attack_feel.play()
	ball.start()
	typewriter.clear()

	await start_feel.play()

	_update_tooltip(1)
	MusicManager.switch_music(&"game_theme")
	Player.Instance.enable_controller()


func _start_ending() -> void:
	wizard_skeleton_spawner.stop_spawning()
	skeleton_queue.stop_spawning()
	var all_wizard_nodes: Array = get_tree().get_nodes_in_group("WizardSkeleton")
	for node in all_wizard_nodes:
		if node is WizardSkeleton:
			var wizard: WizardSkeleton = node as WizardSkeleton
			wizard.stop_draining()

	experience_view.visible = false
	Player.Instance.charge_ratio_changed.connect(_on_player_charged_ratio_changed)


func _end_game() -> void:
	end_feel.play()
	var all_skeleton_nodes: Array = get_tree().get_nodes_in_group("Skeleton")

	var tween: Tween = create_tween()
	for node in all_skeleton_nodes:
		if node is Skeleton:
			var skeleton: Skeleton = node
			tween.tween_callback(skeleton.kill_by_ending)
			tween.tween_interval(0.03)

	await tween.finished

	_is_ended = true
	restart_typewriter.label.visible = true
	restart_typewriter.type_text(restart_typewriter.label.text)
	fireworks_spawner.start_spawning(0.5, -1)
	MusicManager.switch_music(&"ending")


func _on_player_charged_ratio_changed(player_position: Vector2, ratio: float) -> void:
	var camera_focus_ratio: float = ratio * 0.35
	var targetPosition: Vector2 = cameraController.initial_center_position.slerp(player_position, camera_focus_ratio)
	cameraController.focus_at(targetPosition, ratio)

	if ratio >= 1 and _player_first_time_fully_charged:
		_player_first_time_fully_charged = false
		MusicManager.switch_music(&"wind")
		typewriter.type_text("Release Space to Strike!")


func _update_tooltip(level: int) -> void:
	var data: TooltipData
	for t in tooltips:
		if t.show_at_level == level:
			data = t
			break

	if data == null:
		typewriter.clear()
	else:
		typewriter.type_text(data.text)
		if data.display_time >= 0:
			var tween: Tween = create_tween()
			tween.tween_interval(data.display_time)
			tween.tween_callback(typewriter.clear)

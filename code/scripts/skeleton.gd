class_name Skeleton
extends Node2D


signal killed(skeleton: Skeleton)

@export var move_speed: float = 100.0
@export_range(1, 100) var experience: int = 1

@export_group("skull")
@export var skull_scene: PackedScene
@export var skull_marker: Marker2D

@export_group("feel")
@export var light_break_feel: FeelPlayer
@export var mid_break_feel: FeelPlayer
@export var hard_break_feel: FeelPlayer


func move_to(target_position: Vector2) -> void:
	var duration: float = (target_position - global_position).length() / move_speed
	create_tween().tween_property(self, "global_position", target_position, duration)


func take_attack(player: Player, direction: Vector2) -> void:
	var skull: Skull = skull_scene.instantiate()
	get_tree().current_scene.add_child(skull)
	skull.global_position = skull_marker.global_position

	var power: float = player.stats.power
	skull.apply_impulse(direction * power)

	if player.stats.level <= 3:
		light_break_feel.play()
	elif player.stats.level <= 4:
		mid_break_feel.play()
	else:
		hard_break_feel.play()
	_kill()

	player.earn_experience(experience)


func kill_by_ending() -> void:
	light_break_feel.play()
	_kill()


func _kill() -> void:
	killed.emit(self)
	queue_free()

class_name AimSystem
extends Node2D


@export var min_degree: float = 10
@export var max_degree: float = 60
@export var rotate_speed: float = 50
@export var direction_hint_line: Line2D

var _moved_degrees: float = 0


func _process(delta: float) -> void:
	_moved_degrees += rotate_speed * delta
	_moved_degrees = fposmod(_moved_degrees, (max_degree-min_degree)*2)

	direction_hint_line.rotation_degrees = _calculate_current_degree()


func get_direction() -> Vector2:
	var degree: float = _calculate_current_degree()
	return Vector2.from_angle(deg_to_rad(degree))


func change_hint_length(length: float) -> void:
	direction_hint_line.set_point_position(1, Vector2(length, 0))


func _calculate_current_degree() -> float:
	return (min_degree + pingpong(_moved_degrees, max_degree-min_degree)) * -1

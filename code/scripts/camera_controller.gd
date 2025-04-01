class_name CameraController
extends Camera2D


@export_range(10, 1000, 1, "or_greater") var move_speed: float = 100
@export_range(0.1, 10, 0.1, "or_greater") var zoom_speed: float = 1
@export var max_focus_zoom: Vector2 = Vector2.ONE

var initial_center_position: Vector2

var _focus_position: Vector2
var _zoom_in_ratio: float


func _ready() -> void:
	initial_center_position = get_screen_center_position()
	_focus_position = initial_center_position


func _process(delta: float) -> void:
	global_position = global_position.move_toward(_focus_position, move_speed * delta)
	zoom = zoom.move_toward(Vector2.ONE.lerp(max_focus_zoom, _zoom_in_ratio), zoom_speed * delta)


func focus_at(target_position: Vector2, zoom_in_ratio: float = 0) -> void:
	_focus_position = target_position
	_zoom_in_ratio = clampf(zoom_in_ratio, 0, 1)


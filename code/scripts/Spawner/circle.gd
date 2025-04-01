@tool
class_name Circle
extends Shape


@export var radius: float = 10


func random_point() -> Vector2:
	var radian: float = randf_range(0, 2*PI)
	var length: float = randf_range(0, radius)
	return Vector2(length * cos(radian), length * sin(radian))


func draw(canvas_item: CanvasItem) -> void:
	canvas_item.draw_circle(Vector2.ZERO, radius, HINT_COLOR)

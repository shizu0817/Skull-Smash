@tool
class_name Rectangle
extends Shape


@export var width: float = 10.0
@export var height: float = 10.0


func random_point() -> Vector2:
	var x: float = randf_range(-width / 2, width / 2)
	var y: float = randf_range(-height / 2, height / 2)
	return Vector2(x, y)


func draw(canvas_item: CanvasItem) -> void:
	canvas_item.draw_rect(Rect2(-width / 2, -height / 2, width, height), HINT_COLOR)

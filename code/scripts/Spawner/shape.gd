## A Abstract base class for defining geometric shapes in a 2D space.
class_name Shape
extends Resource


const HINT_COLOR: Color = Color(Color.AQUAMARINE, 0.3)


func random_point() -> Vector2:
	push_error("UNIMPLEMENTED ERROR: Shape.random_point")
	return Vector2.ZERO


func draw(_canvas_item: CanvasItem) -> void:
	push_error("UNIMPLEMENTED ERROR: Shape.draw")

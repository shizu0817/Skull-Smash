class_name Typewriter
extends Node


@export var label: Label
##Characters per second
@export_range(0.1, 100) var type_speed: float = 10

var _tween: Tween


func type_text(text: String) -> void:
	if label == null:
		return

	if _tween:
		_tween.kill()

	_tween = create_tween()
	label.text = ""
	for i in range(text.length()):
		if i > 0:
			_tween.tween_interval(1 / type_speed)

		_tween.tween_callback(label.set_text.bind(text.substr(0, i+1)))


func clear() -> void:
	if _tween:
		_tween.kill()

	label.text = ""

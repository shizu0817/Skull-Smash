class_name FeelPlayer
extends Node


@export var feels: Array[FeelComponent]

var _tween: Tween


func play():
	_tween = get_tree().create_tween()
	_tween.set_parallel(true)

	var is_previous_feel_pause: bool = false
	for feel in feels:
		feel.append_tween(self, _tween)

		if feel is Pause:
			is_previous_feel_pause = true
		elif is_previous_feel_pause:
			is_previous_feel_pause = false
			_tween.set_parallel(true)

	await _tween.finished

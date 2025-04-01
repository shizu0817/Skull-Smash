class_name ExperienceView
extends Control


@export var prograss_bar: TextureProgressBar
@export var tween_duration: float = 0.15
@export var level_up_feel: FeelPlayer

var _tween: Tween
var _current_value: float = 0


func _ready() -> void:
	prograss_bar.value = _current_value


func increase_to(new_value: float) -> void:
	if _tween:
		_tween.kill()

	# level up
	if new_value <= _current_value:
		_tween = create_tween()
		_tween.tween_property(prograss_bar, "value", 1, tween_duration / 2)
		_tween.tween_callback(prograss_bar.set_value.bind(0))
		_tween.tween_property(prograss_bar, "value", new_value, tween_duration / 2)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)

		level_up_feel.play()

	# normal
	elif new_value > _current_value:
		_tween = create_tween()
		_tween.tween_property(prograss_bar, "value", new_value, tween_duration)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)

	_current_value = new_value


func decrease_to(new_value: float) -> void:
	if new_value >= _current_value:
		return

	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(prograss_bar, "value", new_value, tween_duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	_current_value = new_value

class_name TimeScale
extends FeelComponent


@export var time_scale: float = 1.0


func append_tween(_feel_player: FeelPlayer, tween: Tween) -> void:
	tween.tween_callback(_change_time_scale)


func _change_time_scale() -> void:
	Engine.time_scale = time_scale

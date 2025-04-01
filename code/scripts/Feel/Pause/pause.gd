class_name Pause
extends FeelComponent


@export var pause_seconds: float = 1


func append_tween(feel_player: FeelPlayer, tween: Tween) -> void:
	tween.set_parallel(false)
	tween.tween_callback(_pause_tween.bind(tween, feel_player.get_tree()))


func _pause_tween(tween: Tween, scene_tree: SceneTree) -> void:
	tween.pause()

	var timer: SceneTreeTimer = scene_tree.create_timer(pause_seconds, false, false, true)
	timer.timeout.connect(tween.play, CONNECT_ONE_SHOT)

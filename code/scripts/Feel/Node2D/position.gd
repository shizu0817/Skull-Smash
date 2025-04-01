class_name Position
extends FeelComponent


@export_node_path("Node2D") var target: NodePath
@export_enum("relative", "absolute") var target_as: String = "relative"
@export var target_position: Vector2
@export var duration: float
@export var transition_type: Tween.TransitionType
@export var ease_type: Tween.EaseType
@export var custom_curve: Curve


func append_tween(_feel_player: FeelPlayer, _tween: Tween) -> void:
	var target_node: Node2D = _feel_player.get_node(target)
	var start_position: Vector2 = target_node.position

	var end_position: Vector2
	if target_as == "relative":
		end_position = target_node.position + target_position
	elif target_as == "absolute":
		end_position = target_position

	if custom_curve != null:
		_tween.tween_method(
			_set_position.bind(target_node, start_position, end_position),
			0., 1., duration)
	else:
		_tween.tween_property(target_node, "position", end_position, duration)\
			.set_trans(transition_type)\
			.set_ease(ease_type)


func _set_position(t: float, node2d: Node2D, start_position: Vector2, end_position: Vector2) -> void:
	var curve_value: float = custom_curve.sample_baked(t)
	var position: Vector2 = start_position.lerp(end_position, curve_value)
	node2d.position = position

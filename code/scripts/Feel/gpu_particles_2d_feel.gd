class_name GPUParticles2DFeel
extends FeelComponent


@export_node_path("GPUParticles2D") var target: NodePath
@export var emitting: bool
@export_range(0, 1, 0.01, "or_greater") var amount_ratio_duration: float = 1.0
@export var amount_ratio_curve: Curve


var _gpu_particles_2d: GPUParticles2D


func append_tween(_feel_player: FeelPlayer, _tween: Tween) -> void:
	if _gpu_particles_2d == null:
		_gpu_particles_2d = _feel_player.get_node(target)

	_tween.tween_callback(_gpu_particles_2d.set_emitting.bind(emitting))

	if amount_ratio_curve != null:
		_tween.tween_method(_set_amount_ratio, 0., 1., amount_ratio_duration)


func _set_amount_ratio(t_normalized: float) -> void:
	var ratio: float = amount_ratio_curve.sample_baked(t_normalized)
	_gpu_particles_2d.set_amount_ratio(ratio)

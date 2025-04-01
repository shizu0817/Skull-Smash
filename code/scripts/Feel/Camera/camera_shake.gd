class_name CameraShake
extends FeelComponent


##How much the camera should shake
@export_range(0, 100, 0.1, "or_greater") var strength: float = 10.0
##How long the camera should shake
@export_range(0, 100, 0.1, "or_greater") var duration: float = 1.0
##The strength curve used to sample the strength ratio over time
@export var strength_curve: Curve
##FastNoiseLite resource used to generate the random camera offset
@export var noise: FastNoiseLite
##How fast the noise sampled offset should move (shake frequency)
@export var noise_move_speed: float = 100
##Whether to reset the camera offset to zero at the end
@export var reset_to_zero: bool = true

var _rand_x: float
var _rand_y: float
var _camera: Camera2D


func append_tween(_feel_player: FeelPlayer, _tween: Tween) -> void:
	_camera = _feel_player.get_viewport().get_camera_2d()

	# initialize values for calculate random camera offset
	_rand_x = randf_range(0, 256)
	_rand_y = randf_range(0, 256)

	_tween.tween_method(_update_camera_offset, 0., 1., duration)
	if reset_to_zero:
		_tween.tween_callback(_camera.set_offset.bind(Vector2.ZERO))


## @param t_normalized is normalized time between 0 and 1
func _update_camera_offset(t_normalized: float) -> void:
	var curve_value: float = strength_curve.sample_baked(t_normalized)
	var noise_vector: Vector2 = _get_noise_vector(duration * t_normalized)
	_camera.offset = curve_value * strength * noise_vector


## @param t is passed time in seconds
func _get_noise_vector(t: float) -> Vector2:
	return Vector2(
		noise.get_noise_2d(_rand_x, t * noise_move_speed),
		noise.get_noise_2d(_rand_y, t * noise_move_speed)
	)

class_name ParticleFeel
extends FeelComponent


@export var particle_scene: PackedScene
@export_enum("feel_owner", "current_scene") var parent: String = "feel_owner"
@export_enum("relative", "absolute") var position_type: String = "relative"
@export var spawn_position: Vector2
@export var free_on_finished: bool = true


var _feel_player: FeelPlayer
var _parent: Node
var _spawn_position: Vector2 = Vector2.ZERO


func append_tween(feel_player: FeelPlayer, tween: Tween) -> void:
	_feel_player = feel_player
	if parent == "current_scene":
		_parent = _feel_player.get_tree().current_scene
	else:
		_parent = _feel_player.owner

	if _feel_player.owner is Node2D and position_type == "relative":
		_spawn_position = _feel_player.owner.global_position + spawn_position
	else:
		_spawn_position = spawn_position

	tween.tween_callback(emit)


func emit() -> void:
	var particle: Node2D = particle_scene.instantiate() as Node2D
	if particle is CPUParticles2D:
		emit_cpu_particle(particle as CPUParticles2D)
	elif particle is GPUParticles2D:
		emit_gpu_particle(particle as GPUParticles2D)


func emit_cpu_particle(cpu_particle: CPUParticles2D) -> void:
	_parent.add_child(cpu_particle)
	cpu_particle.global_position = _spawn_position
	cpu_particle.emitting = true

	if free_on_finished:
		cpu_particle.finished.connect(cpu_particle.queue_free)


func emit_gpu_particle(gpu_particle: GPUParticles2D) -> void:
	_parent.add_child(gpu_particle)
	gpu_particle.global_position = _spawn_position
	gpu_particle.emitting = true

	if free_on_finished:
		gpu_particle.finished.connect(gpu_particle.queue_free)

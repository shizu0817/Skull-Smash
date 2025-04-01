## Preinstantiates gpu particles to complile their shaders to prevent stutter when first spawned in the scene.
## This is not needed in godot 4.4+ forward+/mobile rendering mode
## because of the new ubershaders and pipeline pre-compilation feature.
## For more info:
## https://github.com/godotengine/godot/pull/90400
## https://docs.godotengine.org/en/latest/tutorials/performance/pipeline_compilations.html#pipeline-precompilation-instancing
extends Node


@export var particle_scenes: Array[PackedScene]

var frame_count: int = 0


func _ready() -> void:
	for scene in particle_scenes:
		var particle: GPUParticles2D = scene.instantiate() as GPUParticles2D
		add_child(particle)
		particle.emitting = true


func _process(_delta: float) -> void:
	if frame_count > 1:
		queue_free()
		return

	frame_count += 1

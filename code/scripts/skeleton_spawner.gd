class_name SkeletonSpawner
extends Node


@export var skeleton_scene: PackedScene
@export var shield_skeleton_scene: PackedScene

var _can_spawn_skeleton_with_shield: bool = false


func spawn() -> Skeleton:
	if not _can_spawn_skeleton_with_shield:
		return skeleton_scene.instantiate()
	else:
		if randi_range(0, 1) == 0:
			return skeleton_scene.instantiate()
		else:
			return shield_skeleton_scene.instantiate()


func start_spawning_skeleton_with_shield() -> void:
	_can_spawn_skeleton_with_shield = true

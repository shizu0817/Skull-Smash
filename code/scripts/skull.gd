class_name Skull
extends RigidBody2D


@export var drop_feel: FeelPlayer
@export_flags_2d_physics var floor_layer: int


func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_interval(5)
	tween.tween_callback(queue_free)

	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body is PhysicsBody2D:
		var physics_body: PhysicsBody2D = body as PhysicsBody2D
		if (physics_body.collision_layer & floor_layer) > 0:
			drop_feel.play()
			body_entered.disconnect(_on_body_entered)

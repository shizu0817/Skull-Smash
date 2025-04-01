class_name WizardSkeleton
extends Skeleton


@export_range(0, 1) var drain_ratio: float = 0.1
@export var drain_timer: Timer
@export var drain_cooldown: float = 5
@export var drain_particle_scene: PackedScene
@export var orb_marker: Marker2D
@export var animated_sprite: AnimatedSprite2D
@export var hurtbox: Area2D
@export var drain_feel: FeelPlayer


func _ready() -> void:
	drain_timer.timeout.connect(_drain)
	drain_timer.start(drain_cooldown)
	animated_sprite.animation_finished.connect(animated_sprite.play.bind("Idle"))
	hurtbox.body_entered.connect(_on_body_entered)


func _drain() -> void:
	animated_sprite.play("Drain")

	var player: Player = Player.Instance
	var drain_amount: int = min(ceili(player.stats.max_experience * drain_ratio), player.stats.max_experience)
	player.lost_experience(drain_amount)

	var particle: GPUParticles2D = drain_particle_scene.instantiate() as GPUParticles2D
	add_child(particle)
	particle.global_position = player.global_position
	particle.emitting = true

	var tween: Tween = create_tween()
	tween.tween_property(particle, "position", orb_marker.position, particle.lifetime)
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(particle.queue_free)

	drain_timer.start(drain_cooldown)
	drain_feel.play()


func stop_draining() -> void:
	drain_timer.stop()
	if drain_timer.timeout.is_connected(_drain):
		drain_timer.timeout.disconnect(_drain)


func _on_body_entered(body: Node2D) -> void:
	if body is Skull:
		light_break_feel.play()

		Player.Instance.earn_experience(experience)
		_die()


func _die() -> void:
	stop_draining()
	hurtbox.body_entered.disconnect(_on_body_entered)
	animated_sprite.play("Die")
	await animated_sprite.animation_finished
	_kill()

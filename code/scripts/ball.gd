class_name Ball
extends Area2D


signal broke

@export var black_circle: Texture2D
@export var white_circle: Texture2D
@export var broke_circle: Texture2D
@export var animation_player: AnimationPlayer
@export var particle: GPUParticles2D
@export var back: Sprite2D
@export var face: Node2D
@export var breakFeel: FeelPlayer


func _ready() -> void:
	body_entered.connect(_on_body_entered, CONNECT_ONE_SHOT)


func start() -> void:
	face.visible = true
	back.texture = white_circle
	particle.emitting = true
	animation_player.play("floating")


func _on_body_entered(body: Node2D) -> void:
	if body is Skull:
		_break()


func _break() -> void:
	set_deferred("monitoring", false)
	face.visible = false
	particle.emitting = false
	back.texture = white_circle
	animation_player.stop()

	await breakFeel.play()
	back.texture = broke_circle
	broke.emit()

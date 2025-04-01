class_name HurtBox
extends Area2D


signal on_hit(hitbox: Hitbox)


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox: Hitbox = area as Hitbox
		on_hit.emit(hitbox)

class_name Hitbox
extends Area2D


signal on_hit(hurtbox: HurtBox)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		var hurtbox: HurtBox = area as HurtBox
		on_hit.emit(hurtbox)

class_name PlayerController
extends RefCounted


var _player: Player
var _attack_buffered: bool


func _init(player: Player) -> void:
	_player = player


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if _player.stats.is_charge_mode:
			_handle_charge()
		else:
			_handle_normal_attack()
	elif event.is_action_released("attack") and _player.stats.is_charge_mode:
		_handle_charge_release()


func _handle_normal_attack() -> void:
	if _player.is_attacking:
		if _player.animated_sprite.frame == 1:
			_attack_buffered = true
	else:
		_player.attack()


func _handle_charge() -> void:
	_player.is_charging = true


func _handle_charge_release() -> void:
	if _player.is_fully_charged:
		_player.attack()
		_player.disable_controller()

	_player.is_charging = false


func _on_attack_ended() -> void:
	if _player.stats.is_charge_mode:
		_player.idle()
		return

	if _attack_buffered:
		_attack_buffered = false
		_player.attack()
	else:
		_player.idle()

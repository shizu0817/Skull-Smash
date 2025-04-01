class_name PlayerStats
extends Resource


@export_range(1, 10) var level: int = 1
@export_range(1, 5000) var max_experience: int = 1
@export_range(1, 1000) var power: float = 1
@export var can_break_shield: bool = false
@export var aim_hint_length: float = 0.0
@export var is_charge_mode: bool = false

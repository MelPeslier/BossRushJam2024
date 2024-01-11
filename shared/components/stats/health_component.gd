class_name HealthComponent
extends Node

signal health_changed(_health: float, _max_health: float)

@export var max_health: float
@export var health: float = 1: set = _set_health


func damage(_damage: float) -> void:
	health = health - _damage


func heal(amount: float) -> void:
	health = health + amount


func _set_health(_health: float) -> void:
	health = clampf(_health, 0, max_health)
	health_changed.emit(health, max_health)

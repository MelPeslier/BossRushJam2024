class_name HitboxComponent
extends Area2D

@export var parent: Node2D
@export var attack_data: AttackData
@export var energy_component: EnergyComponent


func _init() -> void:
	collision_layer = 2
	collision_mask = 0

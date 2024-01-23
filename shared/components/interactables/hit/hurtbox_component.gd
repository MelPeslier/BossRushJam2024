class_name HurtboxComponent
extends Area2D

signal hit_received(_attack_data: AttackData, _dir: Vector2)

@export var parent: Node2D
@export var health_component: HealthComponent
@export_range(0, 10, 1) var energy_to_give: float

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: HitboxComponent) -> void:
	if not hitbox:
		return
	if hitbox.parent == parent:
		return
	if hitbox.energy_component and energy_to_give > 0:
		hitbox.energy_component.gain(energy_to_give)

	var attack_data := hitbox.attack_data


	var dir := hitbox.parent.global_position.direction_to(global_position)
	dir.x = 1 if dir.x > 0 else -1
	dir.y = 1 if dir.y > 0 else -1

	if attack_data.team == AttackData.Team.SPIKE:
		hitbox.hit_gived_at.emit( global_position + dir * 0.5 * global_position.distance_to(hitbox.global_position) )

	hit_received.emit(attack_data, dir)



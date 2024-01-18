class_name Dummy
extends CharacterBody2D


@export var components_2d: Node2D
@export var animated_sprite: AnimatedSprite2D

@export_range(1, 10) var damage_threshold: float


func _on_hurtbox_component_hit_received(_kb: float, _dir: Vector2) -> void:
	components_2d.scale.x = _dir.x * abs( components_2d.scale.x )


func _on_health_component_health_damaged(_damage_amount: float) -> void:
	if _damage_amount > damage_threshold:
		animated_sprite.play("hit_normal")
	else:
		animated_sprite.play("hit_low")



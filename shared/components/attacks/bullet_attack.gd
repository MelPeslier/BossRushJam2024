class_name BulletAttack
extends Attack

@export var bullet_scene: PackedScene
@export var marker: Marker2D

func spawn_bullet() -> void:
	var bullet_instance: Bullet = bullet_scene.instantiate() as Bullet
	bullet_instance.init(parent, attack_data)
	bullet_instance.dir = attack_manager.scale.x
	attack_manager.world_2d.add_child(bullet_instance)
	bullet_instance.global_position = marker.global_position


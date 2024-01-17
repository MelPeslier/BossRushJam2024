class_name BulletAttack
extends Attack

@export var bullet_scene: PackedScene
@export var marker: Marker2D

func spawn_bullet() -> void:
	var bullet_instance: Bullet = bullet_scene.instantiate() as Bullet
	bullet_instance.init(parent, attack_data)
	bullet_instance.dir = attack_manager.scale.x
	bullet_instance.global_position = marker.global_position
	get_window().add_child(bullet_instance)


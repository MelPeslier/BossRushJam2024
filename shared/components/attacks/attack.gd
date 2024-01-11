class_name Attack
extends Node2D

var parent: Node2D
var attack_data: AttackData


@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hitbox_component.attack_data = attack_data
	for child in get_children():
		if child is Area2D:
			child.parent = parent
	animation_player.play("activate")


func init(_parent, _attack_data) -> void:
	parent = _parent
	attack_data = _attack_data

class_name Spell
extends Node2D

@export var speed: float = 600

var parent: Node2D
var attack_data: AttackData
var dir: float

@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox_component.attack_data = attack_data
	hitbox_component.parent = parent
	scale.x *= dir


func _physics_process(delta: float) -> void:
	global_position.x += speed * delta * dir


func init(_parent : Node2D, _attack_data : AttackData) -> void:
	parent = _parent
	attack_data = _attack_data

class_name AttackHolder
extends Node2D

signal attack_up(_can_attack: bool, _damage: float)

@export var attack_data: AttackData
@export var attack_scene: PackedScene
@export_range(0.05, 45) var cooldown: float

var can_attack := true: set = _set_can_attack
var parent: Node2D

@onready var timer := Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true


func init(_parent) -> void:
	parent = _parent


func activate(_pos: Vector2 = parent.global_position) -> void:
	spawn_attack(_pos)
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func spawn_attack(_pos : Vector2) -> void:
	var attack_instance = attack_scene.instantiate()
	attack_instance.init(parent, attack_data)
	get_window().add_child(attack_instance)
	attack_instance.scale.x = get_parent().scale.x
	attack_instance.global_position = _pos


func _set_can_attack(_can_attack: bool) -> void:
	can_attack = _can_attack
	attack_up.emit(_can_attack, attack_data.damage)

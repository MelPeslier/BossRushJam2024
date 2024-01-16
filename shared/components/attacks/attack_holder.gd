class_name AttackHolder
extends Node2D

signal attack_up(_can_attack: bool, _damage: float)

@export var attack_data: AttackData
@export var attack_scene: PackedScene
@export_range(0.05, 45) var cooldown: float

var can_attack := true: set = _set_can_attack
var parent: Node2D
var attack_manager: AttackManager
@export var state_machine: StateMachine
@export var ability: State

@onready var timer := Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true


func init(_parent: Node2D, _attack_manager: AttackManager) -> void:
	parent = _parent
	attack_manager = _attack_manager


func activate() -> void:
	spawn_attack()
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func spawn_attack() -> void:
	var attack_instance: Attack = attack_scene.instantiate() as Attack
	attack_instance.init(parent, attack_data, attack_manager, name)
	add_child(attack_instance)
	#attack_instance.scale.x = attack_manager.get_parent().scale.x
	attack_instance.global_position = global_position
	if state_machine and not attack_instance.is_independent:
		state_machine.change_state(ability)
	print(attack_instance.my_name)


func _set_can_attack(_can_attack: bool) -> void:
	can_attack = _can_attack
	attack_up.emit(_can_attack, attack_data.damage)

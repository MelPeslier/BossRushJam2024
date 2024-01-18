class_name AttackHolder
extends Node2D

signal attack_up(_can_attack: bool, _damage: float)

@export var attack_data: AttackData
@export var attack_scene: PackedScene
@export_range(0.05, 45) var cooldown: float

var can_attack := true: set = _set_can_attack
var parent: Node2D
var attack_manager: AttackManager
var state_machine: StateMachine
var energy_component: EnergyComponent
@export var ability: State

@onready var timer := Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true


func init(_parent: Node2D, _attack_manager: AttackManager, _state_machine: StateMachine, _energy_component: EnergyComponent) -> void:
	parent = _parent
	attack_manager = _attack_manager
	state_machine = _state_machine
	energy_component = _energy_component


func activate() -> void:
	spawn_attack()
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func spawn_attack() -> void:
	var attack_instance: Attack = attack_scene.instantiate() as Attack
	attack_instance.init(parent, attack_data, attack_manager, name, energy_component)
	if attack_instance.stick_to_parent:
		add_child(attack_instance)
	else:
		attack_manager.world_2d.add_child(attack_instance)
	attack_instance.global_position = global_position
	if attack_instance.attack_special_effects:
		state_machine.change_state(ability)


func _set_can_attack(_can_attack: bool) -> void:
	can_attack = _can_attack
	attack_up.emit(_can_attack, attack_data.damage)

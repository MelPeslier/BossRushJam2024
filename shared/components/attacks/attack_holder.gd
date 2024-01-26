class_name AttackHolder
extends Node2D

signal attack_up(_can_attack: bool, _damage: float)

@export var attack_data: AttackData
@export var attack_state: PlayerAbilityState

@export_range(0.05, 45) var cooldown: float

var can_attack := true: set = _set_can_attack
var parent: Node2D
var attack_manager: AttackManager
var state_machine: StateMachine
var energy_component: EnergyComponent

@onready var timer := Timer.new()


func _ready() -> void:
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true
	attack_state.attack_holder = self


func init(_parent: Node2D, _attack_manager: AttackManager, _state_machine: StateMachine, _energy_component: EnergyComponent) -> void:
	parent = _parent
	attack_manager = _attack_manager
	state_machine = _state_machine
	energy_component = _energy_component


func activate() -> void:
	state_machine.change_state(attack_state)
	can_attack = false
	timer.start(cooldown)


func _on_timer_timeout() -> void:
	can_attack = true


func _set_can_attack(_can_attack: bool) -> void:
	can_attack = _can_attack
	attack_up.emit(_can_attack, attack_data.damage)

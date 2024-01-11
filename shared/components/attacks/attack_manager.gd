class_name AttackManager
extends Node2D

@export var attack_input_component: AbilityInputComponent

@export_category("Intervals")
@export_range(0.05, 2) var attack_interval_time: float
@export_range(0.05, 2) var attack_buffer_time: float = 0.4
@export_range(0.05, 2) var can_attack_buffer_time: float = 0.4


var attack_interval_timer: float: set = _set_attack_interval_timer
var can_attack_buffer_timer: float: set = _set_can_attack_buffer_timer

var attack_holder: AttackHolder
var parent: Node2D


func init(_parent: Node2D) -> void:
	parent = _parent
	for _attack_holder: AttackHolder in get_children():
		_attack_holder.init(parent)


func process_physics(delta: float) -> void:
	timers(delta)

	if attack_interval_timer > 0:
		if attack_interval_timer - attack_buffer_time > 0:
			attack_holder = null
		return

	if not attack_input_component.can_attack():
		can_attack_buffer_timer -= delta
		if not can_attack_buffer_timer > 0:
			attack_holder = null
		return

	if not attack_holder: return

	launch_attack(attack_holder)

	can_attack_buffer_timer = can_attack_buffer_time
	attack_interval_timer = attack_interval_time
	attack_holder = null


func process_unhandled_input(_event: InputEvent) -> void:
	pass


func timers(delta: float) -> void:
	attack_interval_timer -= delta


func launch_attack(_attack_holder: AttackHolder) -> void:
	attack_holder.activate()


func _set_attack_interval_timer(new_val: float) -> void:
	attack_interval_timer = maxf(0, new_val)

func _set_can_attack_buffer_timer(new_val: float) -> void:
	can_attack_buffer_timer = maxf(0, new_val)

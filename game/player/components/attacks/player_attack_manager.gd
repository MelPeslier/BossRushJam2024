class_name PlayerAttackManager
extends AttackManager


#@export_range(0.05, 2) var combo_interval_time: float = 0.25
@export_range(0.05, 2) var combo_time: float = 0.75


@export var swords: Array[AttackHolder]
@export var hand: EnergyAttackHolder
@export var arm: EnergyAttackHolder

#var combo_interval_timer: float: set = _set_combo_interval_timer
var combo_timer: float: set = _set_combo_timer

var sword_index: int = 0
var wants_sword := false


func process_unhandled_input(_event: InputEvent) -> void:
	if attack_input_component.wants_main_attack():
		attack_holder = swords[0]
		wants_sword = true
	if attack_input_component.wants_secondary_attack():
		wants_sword = false
		if arm.can_attack:
			attack_holder = arm
		elif hand.can_attack:
			attack_holder = hand



func launch_attack() -> void:
	if wants_sword:
		if not combo_timer > 0:
			sword_index = 0

		attack_holder = swords[sword_index]
		sword_index += 1
		sword_index = sword_index % swords.size()
		wants_sword = false
		combo_timer = combo_time

	super()

	#combo_interval_timer = combo_interval_time


func timers(delta: float) -> void:
	super(delta)
	combo_timer -= delta
	#combo_interval_timer -= delta


func _set_combo_timer(new_val: float) -> void:
	combo_timer = maxf(0, new_val)

#func _set_combo_interval_timer(new_val: float) -> void:
	#combo_interval_timer = maxf(0, new_val)

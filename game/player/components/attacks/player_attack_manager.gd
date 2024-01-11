class_name PlayerAttackManager
extends AttackManager


@export_range(0.05, 2) var combo_interval_time: float = 2
@export_range(0.05, 2) var combo_time: float = 2

var combo_interval_timer: float: set = _set_combo_interval_timer
var combo_timer: float: set = _set_combo_timer


func timers(delta: float) -> void:
	super(delta)
	combo_timer -= delta
	combo_interval_timer -= delta


func launch_attack(_attack_holder: AttackHolder) -> void:
	combo_interval_timer = combo_interval_time
	combo_timer = combo_time
	super(_attack_holder)


func _set_combo_timer(new_val: float) -> void:
	combo_timer = maxf(0, new_val)

func _set_combo_interval_timer(new_val: float) -> void:
	combo_interval_timer = maxf(0, new_val)

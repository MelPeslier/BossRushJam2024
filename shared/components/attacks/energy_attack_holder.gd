class_name EnergyAttackHolder
extends AttackHolder

@export_range(0, 30) var energy_cost: float


func init(_parent: Node2D, _attack_manager: AttackManager, _state_machine: StateMachine, _energy_component: EnergyComponent) -> void:
	super(_parent, _attack_manager, _state_machine, _energy_component)
	energy_component.energy_updated.connect(_on_energy_updated)
	can_attack = energy_component.have(energy_cost)


func _on_timer_timeout() -> void:
	if energy_component.have(energy_cost):
		can_attack = true


func activate() -> void:
	super()
	energy_component.use(energy_cost)


func _on_energy_updated(_energy: float, _max_energy: float) -> void:
	if not timer.time_left > 0.0:
		can_attack = energy_component.have(energy_cost)


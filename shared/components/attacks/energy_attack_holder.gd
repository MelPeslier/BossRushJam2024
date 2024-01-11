class_name EnergyAttackHolder
extends AttackHolder

@export var energy_component: EnergyComponent
@export_range(0, 30) var energy_cost: float


func _ready() -> void:
	super()
	energy_component.energy_updated.connect(_on_energy_updated)
	can_attack = energy_component.have(energy_cost)


func _on_timer_timeout() -> void:
	if energy_component.have(energy_cost):
		can_attack = true


func activate(_pos: Vector2 = parent.global_position) -> void:
	super()
	energy_component.use(energy_cost)


func _on_energy_updated() -> void:
	if not timer.time_left > 0.0:
		can_attack = energy_component.have(energy_cost)


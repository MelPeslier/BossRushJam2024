extends CanvasLayer

@export var energy_component: EnergyComponent
@export var health_component: HealthComponent
@export var energy_ability: EnergyAttackHolder
@export var health_point_scene: PackedScene

@export var fill_time: float = 0.25
@export var drop_time: float = 0.4
@export var energy: float: set = _set_energy

@export var fill: TextureRect
@export var health_gui: HBoxContainer
@export var spell_1: GUI_Spell
@export var spell_2: GUI_Spell


var energy_tween: Tween


func _ready() -> void:
	visible = true
	energy_component.energy_updated.connect( _on_energy_updated )
	health_component.health_changed.connect( _on_health_changed )
	energy_component.energy = energy_component.energy
	health_component.health = health_component.health
	for i: int in health_component.max_health:
		var hp: HealthPoint = health_point_scene.instantiate() as HealthPoint
		health_gui.add_child(hp)
		if i + 1 > health_component.health:
			hp.lose_health()
		else:
			hp.gain_health()


func _on_health_changed(_health: float, _max_health: float) -> void:
	for i in health_gui.get_child_count():
		var hp: HealthPoint = health_gui.get_child(i) as HealthPoint
		if i + 1 > health_component.health:
			hp.lose_health()
		else:
			hp.gain_health()


func _on_energy_updated(_energy: float, _energy_max: float) -> void:
	if _energy >= energy_ability.energy_cost:
		spell_1.show_possible()
	else:
		spell_1.hide_possible()

	if _energy >= energy_ability.energy_cost * 2:
		spell_2.show_possible()
	else:
		spell_2.hide_possible()

	var new_energy = clampf( remap(_energy, 0, _energy_max, 0, 1), 0, 1)
	if energy_tween and energy_tween.is_running():
		energy_tween.kill()

	var speed = fill_time if new_energy > energy else drop_time
	#speed *= new_energy - energy

	energy_tween = create_tween()
	energy_tween.tween_property(self, "energy", new_energy, speed)



func _set_energy(new_energy: float) -> void:
	energy = new_energy

	var mat: ShaderMaterial = fill.material as ShaderMaterial
	mat.set_shader_parameter("energy", energy)

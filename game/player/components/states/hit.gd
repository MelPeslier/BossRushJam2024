extends PlayerState

@export var idle: State
@export var die: State
@export_range(0.05, 8) var hit_timer: float = 0.1
@export var attack_input_component: AbilityInputComponent
@export var attack_manager: AttackManager

var is_dead := false


func enter() -> void:
	super()
	attack_input_component.disable_attack()
	move_input_component.disable_input()


func exit() -> void:
	attack_input_component.enable_attack()
	move_input_component.enable_input()


func process_physics(delta: float) -> State:
	super(delta)
	do_air_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()

	if animator.is_playing():
		return null

	return idle



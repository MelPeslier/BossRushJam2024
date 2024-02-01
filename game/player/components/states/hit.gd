extends PlayerState

@export var idle: State
@export var fall: State
@export var attack_input_component: AbilityInputComponent
@export var invicibility_time: float = 0.3

var is_spike := false

func enter() -> void:
	super()
	attack_input_component.disable_attack()
	move_data.disable_move()
	player.hurtbox_component.deactivate()


func exit() -> void:
	attack_input_component.enable_attack()
	move_data.enable_move()
	player.hurtbox_component.activate(invicibility_time)


func process_physics(delta: float) -> State:
	super(delta)

	do_air_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()

	if animated_sprite.is_playing() or is_spike:
		return null

	if parent.is_on_floor():
		return idle
	return fall



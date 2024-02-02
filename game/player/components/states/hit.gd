extends PlayerState

@export var idle: State
@export var fall: State
@export var walk: State
@export var jump: State
@export var dash: State
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
	is_spike = false


func process_physics(delta: float) -> State:
	super(delta)

	do_air_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()

	move_data.jump_buffer_timer -= delta
	move_data.dash_buffer_timer -= delta

	if animated_sprite.is_playing() or is_spike:
		return null


	if move_data.jump_buffer_timer > 0 and move_data.can_jump():
		return jump
	if move_data.dash_buffer_timer > 0 and move_data.can_dash():
		return dash
	if parent.is_on_floor():
		move_data.alter_jumps(move_data.jumps_number)
		if move_data.jump_buffer_timer > 0 and move_data.can_jump():
			return jump
		if move_data.dash_buffer_timer > 0 and move_data.can_dash():
			return dash
		if get_movement_input():
			return walk
		return idle
	return fall


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash():
		move_data.dash_buffer_timer = move_data.dash_buffer_time
	if get_jump():
		move_data.jump_buffer_timer = move_data.jump_buffer_time
	return null

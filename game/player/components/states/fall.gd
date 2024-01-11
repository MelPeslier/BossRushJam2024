extends PlayerState

@export var idle: State
@export var walk: State
@export var jump: State
@export var dash: State

func enter() -> void:
	super()
	move_data.jump_coyote_timer = move_data.jump_coyote_time

func process_physics(delta: float) -> State:
	super(delta)
	move_data.dir = get_movement_input()
	if not move_data.dir or not move_data.can_move:
		do_walk_decelerate(delta)
	else:
		do_walk_accelerate(delta)
	parent.velocity.y += move_data.fall_gravity * delta
	parent.velocity.y = minf(parent.velocity.y, move_data.max_fall_speed)
	#ray_casts.process_physics_right(delta)
	parent.move_and_slide()

	move_data.jump_coyote_timer -= delta
	move_data.jump_buffer_timer -= delta
	move_data.dash_buffer_timer -= delta

	if parent.is_on_floor():
		# Is on floor and will change state, perfect moment to reset jumps
		move_data.alter_jumps(move_data.jumps_number)

		if move_data.jump_buffer_timer > 0 and move_data.can_jump():
			return jump
		if move_data.dash_buffer_timer > 0 and move_data.can_dash():
			return dash

		if get_movement_input():
			return walk
		else:
			return idle
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash():
		if move_data.can_dash():
			return dash
		move_data.dash_buffer_timer = move_data.dash_buffer_time

	if get_jump():
		if move_data.can_jump():
			if not move_data.jump_coyote_timer > 0:
				move_data.alter_jumps(-1)
			return jump
		move_data.jump_buffer_timer = move_data.jump_buffer_time

	return null


func process_frame(_delta: float) -> State:
	return null

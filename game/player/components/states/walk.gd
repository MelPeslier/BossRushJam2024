extends PlayerState

@export var idle: State
@export var jump: State
@export var fall: State
@export var dash: State


func process_physics(delta: float) -> State:
	super(delta)
	move_data.dir = get_movement_input()
	if not move_data.dir or not move_data.can_move:
		return idle
	do_walk_accelerate(delta)
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash() and move_data.can_dash():
		return dash
	if get_jump() and move_data.can_jump():
		return jump
	return null

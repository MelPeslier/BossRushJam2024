extends PlayerState

@export var walk: State
@export var jump: State
@export var fall: State
@export var dash: State

func enter() -> void:
	animated_sprite.offset = Vector2( 0, -89 )
	super()

func process_physics(delta: float) -> State:
	super(delta)
	do_walk_decelerate(delta)
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_movement_input() and move_data.can_move:
		return walk
	if get_jump() and move_data.can_jump():
		return jump
	if get_dash() and move_data.can_dash():
		return dash
	return null

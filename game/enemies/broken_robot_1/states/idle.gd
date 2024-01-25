extends MoveState

@export var walk: State

@export var wait_time: float = 1.3
var wait_timer: float

func enter() -> void:
	super()
	wait_timer = wait_time



func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)
	do_gravity(delta)

	parent.apply_floor_snap()
	parent.move_and_slide()
	return null

func process_frame(_delta: float) -> State:
	wait_timer -= _delta
	if wait_timer <= 0:
		return walk

	if not parent.target: return null

	return null

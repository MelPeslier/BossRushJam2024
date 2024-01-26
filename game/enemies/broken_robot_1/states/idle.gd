extends MoveState

@export var walk: State
@export var run: State
@export var fall: State

@export var wait_time: float = 3.5
var wait_timer: float

func enter() -> void:
	super()
	wait_timer = wait_time


func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)

	parent.apply_floor_snap()
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall

	return null

func process_frame(_delta: float) -> State:
	wait_timer -= _delta

	if parent.target and parent.is_target_valid:
		wait_timer -= _delta
		var dir := parent.global_position.direction_to(parent.target.global_position)
		dir.x = 1 if dir.x > 0 else -1
		move_data.dir = dir.x
		if wait_timer <= 0:
			return run
	if wait_timer <= 0:
		return walk

	return null

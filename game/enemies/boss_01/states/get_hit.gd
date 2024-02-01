extends MoveState

@export var idle: State

@export var down_time: float = 3.5
var down_timer: float

func enter() -> void:
	super()
	down_timer = down_time
	parent.be_down = false


func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)
	parent.move_and_slide()
	return null


func process_frame(delta: float) -> State:
	down_timer -= delta
	if down_timer <= 0:
		return idle

	return null

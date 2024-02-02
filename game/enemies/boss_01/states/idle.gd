extends MoveState

@export var cinematic_wait_time: float = 3.5
@export var idle_time_phase_1: float = 4
@export var idle_time_phase_2: float = 3

@export var pre_walk: State
@export var get_hit: State
@export var aim: State

var start := true
var pre_shot = true
var idle_timer: float = 0

func enter() -> void:
	print("\n\nIDLE ENTERED **********")
	super()
	if start:
		idle_timer = cinematic_wait_time
	elif parent.phase == 1:
		idle_timer = idle_time_phase_1
	elif parent.phase == 2:
		idle_timer = idle_time_phase_2
	if pre_shot:
		idle_timer *= 0.5


func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)
	parent.move_and_slide()
	return null


func process_frame(delta: float) -> State:
	if not parent.target: return null
	if parent.be_down:
		pre_shot = true
		return get_hit

	idle_timer -= delta
	if idle_timer <= 0:
		if start:
			start = false
			return pre_walk
		elif pre_shot:
			pre_shot = false
			return aim
		else:
			pre_shot = true
			return pre_walk

	return null

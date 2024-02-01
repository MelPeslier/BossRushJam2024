extends MoveState

@export var cinematic_wait_time: float = 3
@export var idle_time_phase_1: float = 3
@export var idle_time_phase_2: float = 5

@export var walk: State
@export var get_hit: State
@export var shoot_1: State
@export var shoot_2: State

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
		return get_hit

	idle_timer -= delta
	if idle_timer <= 0:
		if start:
			start = false
			return walk
		elif pre_shot:
			pre_shot = false
			if parent.phase == 1:
				return shoot_1
			elif parent.phase == 2:
				return shoot_2
		else:
			pre_shot = true
			return walk

	return null

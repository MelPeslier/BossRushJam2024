extends MoveState

@export var idle_time_phase_1: float = 3
@export var idle_time_phase_2: float = 5

@export var shoot_1: State
@export var shoot_2: State

var pre_shot = false
var idle_timer: float = 0

func enter() -> void:
	super()
	if parent.phase == 1:
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
	idle_timer -= delta
	if idle_timer <= 0:
		if pre_shot:
			pre_shot = false
			if parent.phase == 1:
				return shoot_1
			elif parent.phase == 2:
				return shoot_2
		else:
			pre_shot = true
			return self

	return null

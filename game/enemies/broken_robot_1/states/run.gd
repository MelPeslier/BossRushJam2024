extends MoveState

@export var terrain_detector: TerrainDetector

func enter() -> void:
	super()


func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	do_walk_accelerate(delta)
	do_gravity(delta)

	parent.apply_floor_snap()
	parent.move_and_slide()
	return null

func process_frame(_delta: float) -> State:
	return null

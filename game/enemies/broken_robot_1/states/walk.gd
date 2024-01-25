extends MoveState

@export var terrain_detector: TerrainDetector
@export var idle: State
@export var wait_time: float = 4.5
var wait_timer: float


func enter() -> void:
	super()
	wait_timer = wait_time


func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	do_walk_accelerate(delta * 0.5)
	do_gravity(delta)

	parent.apply_floor_snap()
	parent.move_and_slide()

	if not parent.target:
		if parent.is_on_wall():
			move_data.dir *= -1

		elif terrain_detector.current_tile_data:
			var edge: float = terrain_detector.current_tile_data.get_custom_data(Terrain.custom_data_layers[1])
			if edge == 1 and move_data.dir == 1:
				move_data.dir = -1
			if edge == -1 and move_data.dir == -1:
				move_data.dir = 1


	return null

func process_frame(_delta: float) -> State:
	if not parent.target: return null

	wait_timer -= _delta
	if wait_timer <= 0:
		return idle

	return null

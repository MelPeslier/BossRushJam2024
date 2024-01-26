extends MoveState

@export var terrain_detector: TerrainDetector

@export var attack_range: float = 450
@export var run_time: float = 2

@export var attack: State
@export var idle: State
@export var fall: State

var run_timer: float = 0

func enter() -> void:
	super()
	run_timer = run_time
	move_data.step_interval_timer *= 0.25


func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	run_timer -= delta
	if parent.target and parent.is_target_valid:
		if parent.is_on_wall():
			move_data.dir *= -1
			run_timer += delta * 10

		var dist := parent.global_position.distance_to(parent.target.global_position)
		var dir := parent.global_position.direction_to(parent.target.global_position)
		dir.x = 1 if dir.x > 0 else -1
		if move_data.dir == dir.x and dist < attack_range:
			return attack
		if run_timer <= 0:
			return attack
	elif run_timer <= 0:
		return idle

	do_walk_accelerate(delta)

	parent.apply_floor_snap()
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall
	return null

func process_frame(delta: float) -> State:
	move_data.step_interval_timer -= delta
	if move_data.step_interval_timer < 0:
		move_data.step_interval_timer = move_data.run_step_interval_time
		match terrain_detector.get_terrain_type():
			Terrain.TerrainType.METAL:
				Sfx2d.play_metal(SoundList.Metal.RUN_LIGHT, parent.global_position)
	return null

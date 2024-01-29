extends MoveState

@export var terrain_detector: TerrainDetector
@export var idle: State
@export var run: State
@export var fall: State

@export var walk_distance: float = 350
@export var wait_time: float = 2.5
var wait_timer: float


func enter() -> void:
	super()
	wait_timer = wait_time
	move_data.step_interval_timer *= 0.5


func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	parent.velocity.x += move_data.dir * move_data.walk_accel * 0.5 * delta
	parent.velocity.x = move_data.dir * min( abs(parent.velocity.x), walk_distance)

	parent.apply_floor_snap()
	parent.move_and_slide()

	if not parent.is_on_floor():
		return fall

	wait_timer -= delta
	if parent.target and parent.is_target_valid:
		var dir := parent.global_position.direction_to(parent.target.global_position)
		dir.x = 1 if dir.x > 0 else -1
		move_data.dir = dir.x
		return run


	if parent.is_on_wall():
		move_data.dir *= -1
		wait_timer += delta * 10
	if wait_timer <= 0:
		return idle

	elif terrain_detector.current_tile_data:
		var edge: float = terrain_detector.current_tile_data.get_custom_data(Terrain.custom_data_layers[1])
		if edge == 1 and move_data.dir == 1:
			move_data.dir = -1
			return idle
		if edge == -1 and move_data.dir == -1:
			move_data.dir = 1
			return idle
	return null

func process_frame(delta: float) -> State:
	move_data.step_interval_timer -= delta
	if move_data.step_interval_timer < 0:
		move_data.step_interval_timer = move_data.walk_step_interval_time
		match terrain_detector.get_terrain_type():
			Terrain.TerrainType.METAL:
				Sfx2d.play_metal_movement(SoundList.MetalMovement.WALK_LIGHT, parent.global_position)
	return null

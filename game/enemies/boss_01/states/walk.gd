extends MoveState

@export_range(1, 5) var walk_speed_coef: float = 1
@export var terrain_detector: TerrainDetector

@export var walk_audio: AudioStreamPlayer2D
@export var idle: State
var speed_coef : float = 1.0

func enter() -> void:
	print("\n\nWALK ENTERED **********")
	super()
	if parent.phase == 1:
		speed_coef = 1
		move_data.step_interval_timer = move_data.walk_step_interval_time
	elif parent.phase == 2:
		speed_coef = walk_speed_coef
		move_data.step_interval_timer = move_data.run_step_interval_time

	animated_sprite.speed_scale = speed_coef


func exit() -> void:
	speed_coef = 1
	animated_sprite.speed_scale = 1


func process_physics(delta: float) -> State:
	parent.velocity.x += move_data.dir * move_data.walk_accel * delta * speed_coef
	parent.velocity.x = move_data.dir * min( abs(parent.velocity.x), move_data.walk_distance * speed_coef )

	parent.move_and_slide()

	if parent.is_on_wall():
		move_data.dir *= -1

		parent.velocity.x += move_data.dir * move_data.walk_accel * delta * speed_coef
		parent.velocity.x = move_data.dir * min( abs(parent.velocity.x), move_data.walk_distance * speed_coef )
		parent.move_and_slide()
		return idle

	return null

func process_frame(delta: float) -> State:
	move_data.step_interval_timer -= delta
	if move_data.step_interval_timer < 0:
		move_data.step_interval_timer = move_data.walk_step_interval_time
		match terrain_detector.get_terrain_type():
			Terrain.TerrainType.METAL:
				#Sfx2d.play_metal_movement(SoundList.MetalMovement.LAND_MEDIUM, parent.global_position)
				walk_audio.play()
	return null

extends MoveState

@export_range(1, 5) var walk_speed_coef: float = 1
@export var terrain_detector: TerrainDetector
@export var walk_particles_scene: PackedScene
@export var step_frames: Array[int] = [1, 11]
@export var step_markers: Array[Marker2D]

@export var walk_audio: AudioStreamPlayer2D
@export var idle: State
var speed_coef : float = 1.0

func enter() -> void:
	super()
	animated_sprite.frame_changed.connect( _on_frame_changed )
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
	animated_sprite.frame_changed.disconnect( _on_frame_changed )


func _on_frame_changed() -> void:
	for i: int in step_frames:
		if animated_sprite.frame == i:
			var marker_index = 0
			if i == 11:
				marker_index = 1
			spawn_step_particles(marker_index)
			match terrain_detector.get_terrain_type():
				Terrain.TerrainType.METAL:
					walk_audio.play()
			break


func spawn_step_particles(_marker_index) -> void:
	var step_particles: ParticlesEffect = walk_particles_scene.instantiate()
	var angle: float = 0
	if move_data.dir == -1:
		angle = PI
	BaseLevel.level.add_child(step_particles)
	step_particles.global_position = step_markers[_marker_index].global_position
	step_particles.activate(angle)


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
		#match terrain_detector.get_terrain_type():
			#Terrain.TerrainType.METAL:
				#walk_audio.play()
	return null

extends PlayerState

@export var jump: State
@export var fall: State
@export var dash: State

@export_category("light_particles")
@export var light_particles_number: int
@export var light_particles_sphere_size: float
@export var light_particles_lifetime: float
@export var light_particles_explosiveness: float

#var light_particles_scene: PackedScene
#var step_light_particles_scene: PackedScene

var want_jump := true


func enter() -> void:
	super()
	#if not parent.is_on_floor():
		#spawn_step_light(move_data.get_jump_coef())
	#spawn_light_particles(move_data.get_jump_coef())
	if move_data.remaining_jumps == move_data.jumps_number:
		match player.terrain_detector.get_terrain_type():
			Terrain.TerrainType.METAL:
				Sfx2d.play_metal(SoundList.Metal.JUMP_MEDIUM, parent.global_position)
	else:
		Sfx2d.play_metal(SoundList.Metal.JUMP_LIGHT, parent.global_position)

	do_jump()
	move_data.alter_jumps(-1)
	move_data.jump_time = 0
	want_jump = true


func process_physics(delta: float) -> State:
	super(delta)
	move_data.jump_time += delta

	if not Input.is_action_pressed("jump"):
		want_jump = false
	var slow: float = 1.0
	if not( want_jump and move_data.jump_time < move_data.jump_time_to_peak ) and\
			move_data.jump_time > move_data.min_jump_time\
	:
		parent.velocity.y += move_data.fall_gravity * delta
		parent.velocity.y = minf(parent.velocity.y, move_data.max_fall_speed)

	else:
		if parent.velocity.y > - move_data.jump_peak_slow_gravity_threshold:
			slow = move_data.jump_peak_slow_gravity_coef

		parent.velocity.y += move_data.gravity * delta * slow

	move_data.dir = get_movement_input()
	if not move_data.dir:
		do_walk_decelerate(delta)
	else:
		do_walk_accelerate(delta)
	parent.move_and_slide()

	if parent.velocity.y > 0:
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash() and move_data.can_dash():
		return dash
	if get_jump() and move_data.can_jump():
		return jump
	return null


func process_frame(_delta: float) -> State:
	return null


#func spawn_step_light(coef: float) -> void:
	#var step_instance = step_light_particles_scene.instantiate()
	#parent.add_child(step_instance)
	#step_instance.position = player.bot_pos.position
	#step_instance.play(coef)
#
#
#func spawn_light_particles(coef: float) -> void:
	#var light_instance = light_particles_scene.instantiate()
	#parent.add_child(light_instance)
	#light_instance.position = player.bot_pos.position
	#var number := int (light_particles_number * coef)
	#light_instance.play(number, light_particles_sphere_size, light_particles_lifetime, light_particles_explosiveness)

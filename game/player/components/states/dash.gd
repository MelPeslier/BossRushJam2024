extends PlayerState

@export var idle: State
@export var walk: State
@export var jump: State
@export var fall: State
@export var dash: State

@export_category("light_particles")
@export var light_particles_number: int
@export var light_particles_sphere_size: float
@export var light_particles_lifetime: float
@export var light_particles_explosiveness: float

var light_particles_scene: PackedScene
var dash_particles_scene: PackedScene


func enter() -> void:
	super()
	move_data.alter_dashes(-1)
	#spawn_particles()
	move_data.dash_timer = move_data.dash_time
	move_data.dash_interval_timer = move_data.dash_interval_time
	parent.velocity.y = 0


func process_physics(delta: float) -> State:
	super(delta)
	do_dash()
	parent.move_and_slide()

	move_data.jump_buffer_timer -= delta
	move_data.dash_buffer_timer -= delta
	move_data.dash_timer -= delta

	if move_data.dash_timer > 0:
		return null

	if parent.is_on_floor():
		move_data.alter_jumps(move_data.jumps_number)

		if move_data.jump_buffer_timer > 0 and move_data.can_jump():
			return jump
		if move_data.dash_buffer_timer > 0 and move_data.can_dash():
			return dash

		if get_movement_input():
			return walk
		return idle

	else:
		# Can jump right after the end of dash if jump availbale
		if move_data.jump_buffer_timer > 0 and move_data.can_jump():
			return jump

	return fall


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash():
		move_data.dash_buffer_timer = move_data.dash_buffer_time

	if get_jump():
		move_data.jump_buffer_timer = move_data.jump_buffer_time

	return null


func process_frame(_delta: float) -> State:
	return null


func spawn_particles() -> void:
	var dash_instance = dash_particles_scene.instantiate()
	parent.add_child(dash_instance)
	dash_instance.position = player.mid_pos.position
	dash_instance.play(move_data.old_dir)

	var light_instance = light_particles_scene.instantiate()
	parent.add_child(light_instance)
	light_instance.position = player.mid_pos.position
	light_instance.play(light_particles_number, light_particles_sphere_size, light_particles_lifetime, light_particles_explosiveness)

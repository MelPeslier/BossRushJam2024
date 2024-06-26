extends PlayerState

@export var idle: State
@export var walk: State
@export var jump: State
@export var fall: State
@export var dash: State

@export var dash_particles_scene: PackedScene
@export var dash_marker: Marker2D


func enter() -> void:
	super()
	spawn_particles()
	move_data.alter_dashes(-1)
	move_data.can_reload_dashes = false
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
	var dash_instance: ParticlesEffect = dash_particles_scene.instantiate() as ParticlesEffect
	parent.add_child(dash_instance)
	dash_instance.global_position = dash_marker.global_position
	var angle: float = 0
	if move_data.old_dir <= 0.0 :
		angle = PI
	dash_instance.activate(angle)


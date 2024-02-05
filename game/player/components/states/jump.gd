extends PlayerState

@export var jump: State
@export var fall: State
@export var dash: State

var want_jump := true


func enter() -> void:
	super()
	if move_data.remaining_jumps == move_data.jumps_number:
		match player.terrain_detector.get_terrain_type():
			Terrain.TerrainType.METAL:
				Sfx2d.play_metal_movement(SoundList.MetalMovement.JUMP_MEDIUM, parent.global_position)
	else:
		Sfx2d.play_metal_movement(SoundList.MetalMovement.JUMP_LIGHT, parent.global_position)

	do_jump()
	move_data.alter_jumps(-1)
	move_data.jump_time = 0
	want_jump = true
	animated_sprite.frame_changed.connect( _on_frame_changed )


func exit() -> void:
	animated_sprite.frame_changed.disconnect( _on_frame_changed )


func _on_frame_changed() -> void:
	var _offset = Vector2.ZERO
	match animated_sprite.frame:
		1:
			_offset = Vector2( 0, -101 )
		2:
			_offset = Vector2( 0, -43 )
		1:
			_offset = Vector2( -13, -30 )
		3:
			_offset = Vector2( -13, -30 )
		4:
			_offset = Vector2( -2, -47 )
		5:
			_offset = Vector2( -2, -47 )
	animated_sprite.offset = _offset


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


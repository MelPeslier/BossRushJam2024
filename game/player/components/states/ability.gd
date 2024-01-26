class_name PlayerAbilityState
extends PlayerState

@export var idle: State
@export var walk: State
@export var dash: State
@export var jump: State

@export var attack_manager: AttackManager
@export var state_machine: StateMachine

var special_effects: AttackSpecialEffects


func enter() -> void:
	animator.play(attack_manager.last_attack.my_name)
	animated_sprite.play(attack_manager.last_attack.my_name)
	player.current_movement_state = player_movement_state
	animated_sprite.animation_finished.connect( _on_animated_sprite_animation_finished )
	special_effects = attack_manager.last_attack.attack_special_effects
	special_effects.dash_timer = special_effects.dash_time


func exit() -> void:
	special_effects = null
	animated_sprite.animation_finished.disconnect( _on_animated_sprite_animation_finished )


func process_physics(delta: float) -> State:
	super(delta)



	move_data.dir = get_movement_input()

	special_effects.dash_timer -= delta
	move_data.jump_buffer_timer -= delta
	move_data.dash_buffer_timer -= delta

	if special_effects.dash_timer > 0:
		parent.velocity.x = special_effects.dash_velocity * move_data.old_dir

	elif special_effects.frame_move != -1 and animated_sprite.frame >= special_effects.frame_move:
		if move_data.jump_buffer_timer > 0 and move_data.can_jump():
			return jump
		if move_data.dash_buffer_timer > 0 and move_data.can_dash():
			return dash

		if move_data.dir:
			do_walk_accelerate(delta)
	else:
		do_walk_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if special_effects.frame_move == -1: return

	if get_dash():
		if move_data.can_dash() and animated_sprite.frame >= special_effects.frame_move:
			return dash
		move_data.dash_buffer_timer = move_data.dash_buffer_time

	if get_jump():
		if move_data.can_jump() and animated_sprite.frame >= special_effects.frame_move:
			return jump
		move_data.jump_buffer_timer = move_data.jump_buffer_time
	return null


func _on_animated_sprite_animation_finished() -> void:
	if not player.current_movement_state == player.MovementState.ABILITY:
		return
	if move_data.dir == 0:
		state_machine.change_state(idle)
		return
	else:
		state_machine.change_state(walk)

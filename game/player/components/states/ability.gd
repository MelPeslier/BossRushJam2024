extends PlayerState

@export var idle: State

@export var attack_manager: AttackManager
@export var state_machine: StateMachine

@export var dash_time: float = 0.06
var dash_timer: float


func enter() -> void:
	animator.play(attack_manager.last_attack.my_name)
	animated_sprite.play(attack_manager.last_attack.my_name)
	player.current_movement_state = player_movement_state
	animated_sprite.animation_finished.connect( _on_animated_sprite_animation_finished, CONNECT_ONE_SHOT )
	dash_timer = dash_time


func process_physics(delta: float) -> State:
	super(delta)

	dash_timer -= delta

	if parent.velocity.y < 0:
		parent.velocity.y += move_data.gravity * delta
	else:
		parent.velocity.y += move_data.fall_gravity * delta
		parent.velocity.y = minf(parent.velocity.y, move_data.max_fall_speed)

	if dash_timer > 0:
		parent.velocity.x = 1600 * move_data.old_dir
	else:
		do_walk_decelerate(delta)

	parent.move_and_slide()
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	return null


func _on_animated_sprite_animation_finished() -> void:
	state_machine.change_state(idle)

class_name PlayerAbilityState
extends PlayerState

@export var state_machine: StateMachine
@export var idle: State
@export var walk: State
@export var dash: State
@export var jump: State

@export_category("Attack Specificity")
@export var attack_frame_start: int = -1
@export var attack_frame_end: int = -1
@export var stick_to_parent := true
@export var attack_juice: Array[PackedScene]

@export_category("Spell to Spawn")
@export var spell_scene: PackedScene = null
@export var marker: Marker2D = null

var attack_holder: AttackHolder

func spawn_spell() -> void:
	var spell_instance: Spell = spell_scene.instantiate() as Spell
	spell_instance.init(parent, attack_holder.attack_data)
	spell_instance.dir = attack_holder.attack_manager.scale.x
	if spell_instance.stick_to_parent:
		add_child(spell_instance)
	elif BaseLevel.level.stuff_2d:
		BaseLevel.level.setuff_2d.add_child(spell_instance)
	else:
		print("player_ability_state : spell added to winddow  :  ", name)
		get_window().add_child(spell_instance)
	if marker:
		spell_instance.global_position = marker.global_position
	else:
		spell_instance.global_position = attack_holder.global_position


func enter() -> void:
	super()
	animated_sprite.animation_finished.connect( _on_animated_sprite_animation_finished )
	animated_sprite.frame_changed.connect( _on_frame_changed )


func _on_animated_sprite_animation_finished() -> void:
	if move_data.dir == 0:
		state_machine.change_state(idle)
		return
	else:
		state_machine.change_state(walk)


func _on_frame_changed() -> void:
	pass


func exit() -> void:
	animated_sprite.animation_finished.disconnect( _on_animated_sprite_animation_finished )
	animated_sprite.frame_changed.disconnect( _on_frame_changed )


func process_physics(delta: float) -> State:
	super(delta)

	move_data.dir = get_movement_input()

	move_data.jump_buffer_timer -= delta
	move_data.dash_buffer_timer -= delta

	if attack_frame_end != -1 and animated_sprite.frame >= attack_frame_end:
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
	if attack_frame_end == -1: return

	if get_dash():
		if move_data.can_dash() and animated_sprite.frame >= attack_frame_end:
			return dash
		move_data.dash_buffer_timer = move_data.dash_buffer_time

	if get_jump():
		if move_data.can_jump() and animated_sprite.frame >= attack_frame_end:
			return jump
		move_data.jump_buffer_timer = move_data.jump_buffer_time
	return null




class_name PlayerAbilityState
extends PlayerState

@export var idle: State
@export var walk: State
@export var dash: State
@export var jump: State
@export var fall: State

@export_category("Attack Specificity")
@export var attack_frame_start: int = -1
@export var attack_frame_end: int = -1
@export var stick_to_parent := false
@export var attack_juice: Array[PackedScene]

@export_category("Spell to Spawn")
@export var spell_scene: PackedScene = null

var attack_holder: AttackHolder


func spawn_spell() -> void:
	var spell_instance: Spell = spell_scene.instantiate() as Spell
	spell_instance.init(parent, attack_holder.attack_data)
	spell_instance.dir = attack_holder.attack_manager.scale.x
	if stick_to_parent:
		add_child(spell_instance)
	elif BaseLevel.level.stuff_2d:
		BaseLevel.level.stuff_2d.add_child(spell_instance)
	else:
		print("player_ability_state : spell added to winddow  :  ", name)
		get_window().add_child(spell_instance)

	spell_instance.global_position = attack_holder.global_position


func enter() -> void:
	super()
	animated_sprite.frame_changed.connect( _on_frame_changed )
	if attack_holder.hitbox_component and not attack_holder.hitbox_component.hit_gived_at.is_connected(_on_hitbox_component_hit_gived_at):
		attack_holder.hitbox_component.hit_gived_at.connect( _on_hitbox_component_hit_gived_at )
	if attack_frame_start == -1:
		activate()



func exit() -> void:
	animated_sprite.frame_changed.disconnect( _on_frame_changed )
	if attack_frame_end == -1:
		deactivate()


func _on_frame_changed() -> void:
	if animated_sprite.frame == attack_frame_start:
		activate()
		return

	if animated_sprite.frame == attack_frame_end:
		deactivate()
		return


func activate() -> void:
	if attack_holder.asp_hit_emit:
		attack_holder.asp_hit_emit.play()
	if attack_holder.hitbox_component:
		attack_holder.hitbox_component.activate()
	if spell_scene:
		spawn_spell()


func deactivate() -> void:
	if attack_holder.hitbox_component:
			attack_holder.hitbox_component.deactivate()


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
		if move_data.dir == 0 and parent.is_on_floor():
			return walk
		else:
			return fall

	do_walk_decelerate(delta)

	parent.velocity.y = 0
	parent.move_and_slide()

	if not animated_sprite.is_playing():
		if move_data.jump_buffer_timer > 0 and move_data.can_jump():
			return jump
		if move_data.dash_buffer_timer > 0 and move_data.can_dash():
			return dash
		if move_data.dir == 0:
			return idle
		return walk

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


func _on_hitbox_component_hit_gived_at(_pos: Vector2) -> void:
	Sfx2d._play(attack_holder.asp_hit_gived_at, _pos)


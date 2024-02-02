class_name BossShootState
extends MoveState

@export var idle: State
@export var pre_walk: State

@export var spell_scene : PackedScene
@export var attack_data: AttackData
@export var attacks: Node2D
@export var marker: Marker2D
@export var stick_to_parent: bool = false

@export var shoot_audio: AudioStreamPlayer2D

#nb attacks / interval
@export var shoot_attacks: Array = [
	[1, 1.1],
	[2, 0.5],
	[3, 0.33],
]
@export_range(0, 180) var angle_diff_margin: float
@export var attack_frame_start : int
@export var attack_frame_end : int

var pattern_index: int = 0
var attack_index: int = 0
var finished := false
var interval_timer : float = 0


func spawn_spell() -> void:
	var spell_instance: Spell = spell_scene.instantiate() as Spell

	var angle_to_player = marker.global_position.angle_to_point(parent.target.global_position)
	angle_to_player = MyRng.get_random(angle_to_player, deg_to_rad( angle_diff_margin ) )

	spell_instance.init(parent, attack_data, angle_to_player)

	if stick_to_parent:
		add_child(spell_instance)
	elif BaseLevel.level.stuff_2d:
		BaseLevel.level.stuff_2d.add_child(spell_instance)
	else:
		print("player_ability_state : spell added to winddow  :  ", name)
		get_window().add_child(spell_instance)

	spell_instance.global_position = marker.global_position
	shoot_audio.play()


func enter() -> void:
	super()
	pattern_index = 0
	attack_index = 0
	finished = false
	animated_sprite.frame_changed.connect( _on_frame_changed )
	animated_sprite.animation_finished.connect( _on_animation_finished )


func exit() -> void:
	animated_sprite.frame_changed.disconnect( _on_frame_changed )
	animated_sprite.animation_finished.disconnect( _on_animation_finished )


func _on_frame_changed() -> void:
	if animated_sprite.frame == attack_frame_start:
		spawn_spell()
		print("attack index : ", attack_index, "   pattern index : ", pattern_index)
		attack_index += 1

		if attack_index >= shoot_attacks[pattern_index][0]:
			pattern_index += 1
			attack_index = 0



func _on_animation_finished() -> void:
	if pattern_index >= shoot_attacks.size() :
		finished = true
		return
	interval_timer = shoot_attacks[pattern_index][1]


func process_physics(_delta: float) -> State:
	if not parent.target: return idle

	var dir := parent.global_position.direction_to(parent.target.global_position)
	dir.x = 1 if dir.x > 0 else -1
	if signf( move_data.dir ) != signf( dir.x ):
		idle.pre_shot = true
		return pre_walk

	return null


func process_frame(delta: float) -> State:
	if not parent.target: return idle

	if finished and not animated_sprite.is_playing():
		return idle
	interval_timer -= delta
	if interval_timer <= 0:
		animated_sprite.play(animation_name)

	return null




extends MoveState

@export var idle: State
@export var fall: State
@export var attack_frame_start: int = 9
@export var attack_frame_end: int = 11
@export var attack_01_hitbox: HitboxComponent
@export var swoosh: AudioStreamPlayer2D
@export var hit_gived: AudioStreamPlayer2D


func _ready() -> void:
	attack_01_hitbox.deactivate()


func enter() -> void:
	super()
	animated_sprite.frame_changed.connect( _on_frame_changed )


func exit() -> void:
	animated_sprite.frame_changed.disconnect( _on_frame_changed )
	attack_01_hitbox.deactivate()

func _on_frame_changed() -> void:
	if animated_sprite.frame == attack_frame_start:
		attack_01_hitbox.activate()
		swoosh.play()
	if  animated_sprite.frame == attack_frame_end:
		attack_01_hitbox.deactivate()


func process_physics(delta: float) -> State:
	if not animated_sprite.is_playing():
		if not parent.is_on_floor():
			return fall
		return idle

	do_walk_decelerate(delta)
	do_gravity(delta)

	parent.apply_floor_snap()
	parent.move_and_slide()

	return null

func _on_attack_01_hitbox_hit_gived_at(_pos: Vector2) -> void:
	hit_gived.play()

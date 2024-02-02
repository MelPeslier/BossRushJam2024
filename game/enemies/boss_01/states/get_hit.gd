extends MoveState

@export var pre_walk: State
@export var frame_hit_break: int = 6
@export var down_time: float = 3.5
var down_timer: float
var pause := false
var done := false

func enter() -> void:
	super()
	Music.fade_sounds(Music.Fade.IN, 1, Vector2( 2, 0))
	done = false
	pause = false
	down_timer = down_time
	parent.be_down = false
	animated_sprite.frame_changed.connect( _on_frame_changed )


func exit() -> void:
	animated_sprite.frame_changed.disconnect( _on_frame_changed )


func _on_frame_changed() -> void:
	if animated_sprite.frame == frame_hit_break:
		pause = true
		animated_sprite.pause()


func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)
	parent.move_and_slide()
	return null


func process_frame(delta: float) -> State:
	if done and not animated_sprite.is_playing():
		return pre_walk
	if pause and not animated_sprite.is_playing():
		down_timer -= delta
		if down_timer <= 0:
			animated_sprite.play()
			pause = false
			done = true
	return null

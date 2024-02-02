extends MoveState

@export var walk: State
@export var phase_2_walk_start_frame : int
var go_walk := false

func enter() -> void:
	super()
	go_walk = false
	animated_sprite.frame_changed.connect( _on_frame_changed )


func exit() -> void:
	animated_sprite.frame_changed.disconnect( _on_frame_changed )


func _on_frame_changed() -> void:
	if parent.phase == 2 and animated_sprite.frame == phase_2_walk_start_frame:
		go_walk = true


func process_frame(delta: float) -> State:
	if not animated_sprite.is_playing() or go_walk:
		return walk
	return null

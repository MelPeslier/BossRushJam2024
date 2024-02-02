extends MoveState

@export var walk: State
@export var phase_2_walk_start_frame : int
@export var sound_frames : Array[int]
@export var pre_walk_audio: AudioStreamPlayer2D
@export var pre_walk_audio_2: AudioStreamPlayer2D
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
	if animated_sprite.frame == sound_frames[0]:
		if parent.phase == 2:
			pre_walk_audio_2.play()
		else:
			pre_walk_audio.play()
	if animated_sprite.frame == sound_frames[1]:
		pre_walk_audio_2.play()



func process_frame(_delta: float) -> State:
	if not animated_sprite.is_playing() or go_walk:
		return walk
	return null

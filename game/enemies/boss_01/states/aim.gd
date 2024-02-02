extends MoveState

@export var shoot_1: State
@export var shoot_2: State

@export var aim: AudioStreamPlayer2D
@export var aim_2: AudioStreamPlayer2D

func enter() -> void:
	super()
	if parent.phase == 1:
		aim.play()
	elif parent.phase == 2:
		aim_2.play()


func process_frame(_delta: float) -> State:
	if not animated_sprite.is_playing():
		if parent.phase == 1:
			return shoot_1
		elif parent.phase == 2:
			return shoot_2
	return null

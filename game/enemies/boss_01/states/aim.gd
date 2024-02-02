extends MoveState

@export var shoot_1: State
@export var shoot_2: State


func process_frame(delta: float) -> State:
	if not animated_sprite.is_playing():
		if parent.phase == 1:
			return shoot_1
		elif parent.phase == 2:
			return shoot_2
	return null

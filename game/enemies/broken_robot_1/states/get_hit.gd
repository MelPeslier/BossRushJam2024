extends MoveState

@export var idle: State
@export var fall: State

func enter() -> void:
	super()


func exit() -> void:
	pass

func process_physics(_delta: float) -> State:
	if animated_sprite.is_playing(): return null

	if not parent.is_on_floor(): return fall

	return idle


func process_frame(_delta: float) -> State:
	return null

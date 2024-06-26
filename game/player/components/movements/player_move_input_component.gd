extends MoveInputComponent

@export var player: Player


func get_movement_direction() -> float:
	return Input.get_axis('left', 'right')

func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("up")

func wants_dash() -> bool:
	return Input.is_action_just_pressed("dash") or Input.is_action_just_pressed("down")

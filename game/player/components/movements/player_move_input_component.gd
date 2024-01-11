extends MoveInputComponent

@export var player: Player
@export var move_data: MoveData

var _can_move: bool = true


func get_movement_direction() -> float:
	return Input.get_axis('left', 'right')

func wants_jump() -> bool:
	return Input.is_action_just_pressed("jump")

func wants_dash() -> bool:
	return Input.is_action_just_pressed("dash")


func can_jump() -> bool:
	return move_data.remaining_jumps > 0 and can_move()

func alter_jumps(val: int) -> void:
	move_data.remaining_jumps = clampi(move_data.remaining_jumps + val, 0, move_data.jumps_number)

func get_jump_coef() -> float:
	return 1.0 - move_data.next_jumps_coef * ( move_data.jumps_number - move_data.remaining_jumps )


func can_dash() -> bool:
	return move_data.remaining_dashes > 0 and can_move

func alter_dashes(val: int) -> void:
	move_data.remaining_dashes = clampi(move_data.remaining_dashes + val, 0, move_data.dashes_number)

func reload_dashes() -> void:
	alter_dashes(move_data.dashes_number)


func can_move() -> bool:
	return _can_move

func disable_move() -> void:
	_can_move = false

func enable_move() -> void:
	_can_move = true

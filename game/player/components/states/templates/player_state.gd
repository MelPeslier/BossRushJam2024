class_name PlayerState
extends MoveState

@onready var player_movement_state: Player.MovementState = Player.MovementState[name.to_upper()]

var player: Player

func _ready() -> void:
	parent_update.connect(_on_parent_update, CONNECT_ONE_SHOT)


func _on_parent_update() -> void:
	player = parent

func process_physics(delta: float) -> State:
	# Dash
	move_data.dash_interval_timer -= delta
	if not move_data.dash_interval_timer > 0:
		if move_data.can_reload_dashes:
			move_data.reload_dashes()

	if parent.is_on_floor() and move_data.remaining_dashes != move_data.dashes_number :
		move_data.can_reload_dashes = true
	return null

func enter() -> void:
	super()
	player.current_movement_state = player_movement_state


func get_movement_input() -> float:
	if not move_data.can_move():
		return 0
	return move_input_component.get_movement_direction()

func get_jump() -> bool:
	return move_input_component.wants_jump()


func get_dash() -> bool:
	return move_input_component.wants_dash()

extends PlayerState

@export var idle: State
@export var die: State
@export_range(0.05, 8) var hit_timer: float = 0.1

var is_dead := false


func enter() -> void:
	super()
	move_data.disable_attack()
	move_data.disable_input()


func exit() -> void:
	move_data.enable_attack()
	move_data.enable_input()


func process_physics(delta: float) -> State:
	super(delta)
	do_air_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()

	if animator.is_playing():
		return null

	if is_dead:
		return die

	return idle

# Listening HurtboxComponent
func _on_hit_received(kb: Vector2) -> void:
	player.movement_state_machine.change_state(self)
	parent.velocity = kb


func _on_health_component_health_changed(_health: float, _max_health: float) -> void:
	if _health == 0:
		is_dead = true

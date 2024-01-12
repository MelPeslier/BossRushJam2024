class_name Player
extends CharacterBody2D

enum MovementState{
	DASH,
	DIE,
	FALL,
	HIT,
	IDLE,
	JUMP,
	WALK,
}

@export_category("Components & Nodes")
@export var movement_state_machine: StateMachine
@export var movement_animator: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var move_input_component: MoveInputComponent
@export var health_component: HealthComponent
@export var move_data: MoveData
@export var attack_manager: PlayerAttackManager
@export var interactor_component: PlayerInteractorComponent
@export var bot_pos: Marker2D
@export var mid_pos: Marker2D
@export var camera: MyCamera


var current_movement_state: MovementState

var _can_receive_input := true



func _ready() -> void:
	movement_state_machine.init(self, movement_animator, animated_sprite, move_input_component, move_data)


func _unhandled_input(event: InputEvent) -> void:
	if not can_receive_input(): return
	movement_state_machine.process_unhandled_input(event)
	attack_manager.process_unhandled_input(event)
	interactor_component.process_unhandled_input(event)


func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	attack_manager.process_physics(delta)
	interactor_component.process_physics(delta)


func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)


#region Can do
func can_receive_input() -> bool:
	return _can_receive_input

func disable_input() -> void:
	_can_receive_input = false

func enable_input() -> void:
	_can_receive_input = true
#endregion


#region Signals Connected
func _on_move_data_dir_changed(new_dir: int) -> void:
	animated_sprite.flip_h = new_dir < 0
	attack_manager.scale.x = float( new_dir )
	mid_pos.scale.x = float( new_dir )
	bot_pos.scale.x = float( new_dir )
#endregion



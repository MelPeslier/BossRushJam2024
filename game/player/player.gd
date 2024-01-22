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
	ABILITY,
}

@export_category("level")
@export var world_2d: Node2D

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
@export var need_dir: Array[Node2D]

var current_movement_state: MovementState


func _ready() -> void:
	movement_state_machine.init(self, movement_animator, animated_sprite, move_input_component, move_data)
	GameEvents.cinematic_ended.connect( _on_cinematic_ended )
	GameEvents.cinematic_started.connect( _on_cinematic_started )
	GameEvents.menu_opened.connect( _on_menu_opened )
	GameEvents.menu_closed.connect( _on_menu_closed )
	attack_manager.init(self, movement_state_machine, world_2d)



func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_unhandled_input(event)
	attack_manager.process_unhandled_input(event)
	interactor_component.process_unhandled_input(event)


func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	attack_manager.process_physics(delta)
	interactor_component.process_physics(delta)


func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)


#region Signals Connected
func _on_move_data_dir_changed(new_dir: float) -> void:
	for node: Node2D in need_dir:
		node.scale.x = new_dir * abs( node.scale.x )
#endregion

func _on_menu_opened() -> void:
	movement_state_machine.change_state(movement_state_machine.starting_state)
	set_process_unhandled_input(false)

func _on_menu_closed() -> void:
	set_process_unhandled_input(true)


func _on_cinematic_started() -> void:
	set_process_unhandled_input(false)
	set_physics_process(false)
	set_process(false)
	movement_state_machine.change_state(movement_state_machine.starting_state)

func _on_cinematic_ended() -> void:
	set_process_unhandled_input(true)
	set_physics_process(true)
	set_process(true)



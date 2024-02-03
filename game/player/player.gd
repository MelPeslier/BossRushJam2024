class_name Player
extends CharacterBody2D

signal battle(_add: int)

enum MovementState{
	DASH,
	DIE,
	FALL,
	HIT,
	IDLE,
	JUMP,
	WALK,
	SWORD_1,
	SWORD_2,
	SWORD_3,
	HAND,
	ARM,
}

@export var spike_hit_in: float = 0.2
@export var spike_hit_out: float = 0.3

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
@export var my_collision_shape: CollisionShape2D
@export var terrain_detector: TerrainDetector
@export var hurtbox_component: HurtboxComponent
@export var hit_transition: TransitionScreen
@export var battle_timer: Timer
@export var flash_effect: FlashEffect

@export var die: State
@export var hit: State


var current_movement_state: MovementState
var last_collider: KinematicCollision2D
var last_collider_ground: KinematicCollision2D

static var move_speed: float = -1 : set = _set_move_speed
var ennemies : int
var in_battle : bool = false

func _ready() -> void:
	battle.connect( _on_battle )
	move_speed = move_data.walk_distance
	movement_state_machine.init(self, movement_animator, animated_sprite, move_input_component, move_data)
	GameEvents.cinematic_ended.connect( _on_cinematic_ended )
	GameEvents.cinematic_started.connect( _on_cinematic_started )
	GameEvents.menu_opened.connect( _on_menu_opened )
	GameEvents.menu_closed.connect( _on_menu_closed )
	attack_manager.init(self, movement_state_machine)



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


func is_alive() -> bool:
	return health_component.health > 0


func _on_hurtbox_component_hit_received(_attack_data: AttackData, _dir: Vector2) -> void:
	if attack_manager.last_attack and is_instance_valid( attack_manager.last_attack ):
		attack_manager.last_attack.interupt()

	health_component.damage(_attack_data.damage)
	velocity = _attack_data.knock_back * _dir


	if health_component.health == 0:
		movement_state_machine.change_state(die)
		flash_effect.flash_twice()
		return

	flash_effect.flash_normal()
	movement_state_machine.change_state(hit)

	if _attack_data.team == AttackData.Team.SPIKE:

		hit.is_spike = true

		var timer := Timer.new()
		add_child(timer)
		timer.start(spike_hit_in)

		hit_transition.appear(spike_hit_in)

		timer.start(spike_hit_in)
		await timer.timeout

		global_position = terrain_detector.last_ground_tile_position
		move_data.reload_dashes()
		move_data.alter_jumps(move_data.jumps_number)

		timer.start(0.2)
		await timer.timeout
		timer.queue_free()

		hit_transition.disappear(spike_hit_out)
		hit.is_spike = false


static func _set_move_speed(_new_speed: float) -> void:
	move_speed = _new_speed
	GameEvents.player_move_speed_changed.emit(move_speed)


func _on_battle(_add : int) -> void:
	ennemies += _add
	ennemies = maxi(ennemies, 0)
	if ennemies == 0:
		battle_timer.start()
	elif not in_battle:
		battle_timer.stop()
		in_battle = true
		BaseLevel.level.alternative_loop_start.emit()


func _on_battle_timer_timeout() -> void:
	if ennemies == 0:
		in_battle = false
		BaseLevel.level.music_loop_start.emit()

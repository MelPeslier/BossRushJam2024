extends CharacterBody2D

@export_file("*.tscn") var next_scene_path: String

@export var need_dir: Array[Node2D]
@export var flash_effect: FlashEffect
@export var state_machine: StateMachine
@export var animator: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var move_input_component: Node
@export var move_data: MoveData
@export var terrain_detector: TerrainDetector
@export var health_component: HealthComponent

@export var get_hit: State
@export var dead: State

@export_category("Specific")
@export var phase_2_threshold: float = 0.5

var target: Node2D
var phase: int = 1
var be_down = false

func _ready() -> void:
	state_machine.init(self, animator, animated_sprite, move_input_component, move_data)
	move_data.dir = - move_data.dir
	GameEvents.player_died.connect( _on_player_died )


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_unhandled_input(event)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _on_move_data_dir_changed(new_dir: float) -> void:
	for node: Node2D in need_dir:
		node.scale.x = new_dir * abs( node.scale.x )


func _on_player_died(_pos: Vector2) -> void:
	target = null


func _on_hurtbox_component_hit_received(_attack_data: AttackData, _dir: Vector2) -> void:
	health_component.damage(_attack_data.damage)
	if _attack_data.damage >= 3:
		flash_effect.flash_twice()
	else:
		flash_effect.flash_normal()

	if phase == 1:
		if health_component.health <= health_component.max_health * phase_2_threshold:
			phase = 2
			be_down = true
	elif not health_component.alive:
		state_machine.change_state(dead)


func _on_my_camera_spot_player_entered(_player: Player) -> void:
	target = _player


func _on_animated_sprite_2d_animation_changed() -> void:
	var _offset := Vector2.ZERO
	match animated_sprite.animation:
		&"aim":
			_offset = Vector2( 100, 1 )
		&"dead":
			_offset = Vector2( 34, 28 )
		&"get_hit":
			_offset = Vector2( 0, -10 )
		&"idle":
			_offset = Vector2( 0, 0 )
		&"pre_walk":
			_offset = Vector2( 0, -7 )
		&"shoot_1":
			_offset = Vector2( 100, 1 )
		&"shoot_2":
			_offset = Vector2( 100, 1 )
		&"walk":
			_offset = Vector2( 0, -7 )
	animated_sprite.offset = _offset

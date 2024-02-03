extends CharacterBody2D

@export var need_dir: Array[Node2D]
@export var aggro_time: float = 5

@onready var state_machine: StateMachine = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_input_component: Node = $MoveInputComponent
@onready var move_data: MoveData = $MoveData
@onready var terrain_detector: TerrainDetector = $TerrainDetector
@onready var health_component: HealthComponent = $HealthComponent
@onready var hit: State = $StateMachine/get_hit
@onready var die: State = $StateMachine/dead
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var detected: AudioStreamPlayer2D = $detected
@onready var losed: AudioStreamPlayer2D = $losed

@export var flash_effect: FlashEffect


var target: Node2D
var is_target_valid := false
var losing_aggro := false
var aggro_timer: float = 0


func _ready() -> void:
	state_machine.init(self, animator, animated_sprite, move_input_component, move_data)
	move_data.dir = -move_data.dir
	move_data.dir = -move_data.dir
	ray_cast_2d.enabled = false
	GameEvents.player_died.connect( _on_player_died )


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_unhandled_input(event)


func _physics_process(delta: float) -> void:
	if target and not is_target_valid:
		if ray_cast_2d.enabled:
			ray_cast_2d.target_position = to_local(target.global_position)
			ray_cast_2d.force_raycast_update()
			if not ray_cast_2d.is_colliding():
				is_target_valid = true
				ray_cast_2d.enabled = false
				var player: Player = target as Player
				player.battle.emit(1)
				detected.play()
				#Start chase
		else:
			aggro_timer = 0

	if losing_aggro:
		aggro_timer -= delta
		if aggro_timer <= 0:
			var player: Player = target as Player
			player.battle.emit(-1)
			target = null
			losing_aggro = false
			is_target_valid = false
			losed.play()


	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _on_move_data_dir_changed(new_dir: float) -> void:
	for node: Node2D in need_dir:
		node.scale.x = - new_dir * abs( node.scale.x )


func _on_detector_body_entered(body: Node2D) -> void:
	if not body is Player: return
	var player = body as Player
	if not player.is_alive(): return
	ray_cast_2d.enabled = true
	target = body
	losing_aggro = false


func _on_detector_body_exited(body: Node2D) -> void:
	if not body is Player: return
	var player = body as Player

	if not player.is_alive(): return
	ray_cast_2d.enabled = false
	aggro_timer = aggro_time

	if is_target_valid:
		losing_aggro = true
	else:
		losing_aggro = false
		target = null


func _on_player_died(_pos: Vector2) -> void:
	ray_cast_2d.enabled = false
	target = null
	losing_aggro = false
	is_target_valid = false




func _on_hurtbox_component_hit_received(_attack_data: AttackData, _dir: Vector2) -> void:
	#interupt()
	health_component.damage(_attack_data.damage)
	velocity = _attack_data.knock_back * _dir

	var next_state: State = hit
	if health_component.health == 0:
		flash_effect.flash_twice()
		next_state = die
		if target and target is Player:
			target.battle.emit(-1)
	else:
		flash_effect.flash_normal()
	state_machine.change_state(next_state)



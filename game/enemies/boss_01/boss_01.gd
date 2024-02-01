extends CharacterBody2D

@export var need_dir: Array[Node2D]

@export var state_machine: StateMachine
@export var animator: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var move_input_component: Node
@export var move_data: MoveData
@export var terrain_detector: TerrainDetector
@export var health_component: HealthComponent
@export var detector_collision: CollisionShape2D
@export var get_hit: State
@export var dead: State

@export_category("Specific")
@export var phase_2_threshold: float = 0.5

@export_category("Music")
@export_range(-60, 0) var db_music_volume: float = 0
@export_file("*.wav") var music_intro_path: String = ""
@export_file("*.wav") var music_loop_1_path: String = ""
@export_file("*.wav") var music_loop_2_path: String = ""
@onready var music_loop_paths: Array[String] = [music_loop_1_path, music_loop_2_path]

var target: Node2D
var phase: int = 1

func _ready() -> void:
	detector_collision.disabled = false
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
	if phase == 1:
		if health_component.health <= health_component.max_health * phase_2_threshold:
			phase = 2
			Music.fade_sounds(Music.Fade.IN, 1)
			state_machine.change_state(get_hit)
	elif not health_component.alive:
			state_machine.change_state(dead)
	else:
		hit_no_state()


func hit_no_state() -> void:
	pass


func _on_detector_body_entered(body: Node2D) -> void:
	if not body is Player: return
	detector_collision.set_deferred("disabled", true)

	#TODO le combat commence !
	Music.change_sounds([music_intro_path], Music.CrossFade.OUT_IN)
	Music.audio_stream_players[0].finished.connect( _on_intro_finished, CONNECT_ONE_SHOT )
	target = body

func _on_intro_finished() -> void:
	if music_loop_paths.is_empty(): return
	Music.change_sounds(music_loop_paths, Music.CrossFade.NONE)

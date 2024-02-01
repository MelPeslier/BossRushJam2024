class_name BaseLevel
extends Node2D

@export_file("*.wav") var music_intro_path: String
@export_file("*.wav") var music_loop_1_path: String
@export_file("*.wav") var music_loop_2_path: String
@export_file("*.wav") var music_loop_3_path: String

@export var for_player: Node2D
var player : Player
@onready var music_loop_paths: Array[String] = [music_loop_1_path, music_loop_2_path, music_loop_3_path]

var i: int = 0;
var forward:= true

static var level: BaseLevel = null

@export var stuff_2d: Node2D
@export var level_path: String
@export var particles: Node2D
@onready var player_scene: PackedScene = preload("res://game/player/player.tscn")


func _ready() -> void:
	level = self
	var player_instance :Player = player_scene.instantiate() as Player
	player = player_instance
	for_player.add_child(player_instance)

	for ep: EnvironementParticles in particles.get_children():
		ep.player = player

	Music.change_sounds( [music_intro_path], Music.CrossFade.CROSS )
	Music.audio_stream_players[0].finished.connect( _on_intro_finished, CONNECT_ONE_SHOT )
	GameState.in_game = true

	if not GameState.saved_game.level_path == level_path:
		GameState.saved_game.level_check_point_id = 0
		GameState.saved_game.level_path = level_path
		GameState.save_game()

	for checkpoint: Checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		if checkpoint.id == GameState.saved_game.level_check_point_id:
			player.global_position = checkpoint.global_position - Vector2(0, player.my_collision_shape.shape.get_rect().size.y)
			break


func _on_intro_finished() -> void:
	Music.change_sounds(music_loop_paths, Music.CrossFade.NONE)

# TODO DELETE : ONLY for testing
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"):
		enable_next_song()


func enable_next_song() -> void:
	if forward:
		i += 1
		Music.fade_sounds(Music.Fade.IN, i)
		if i == 3:
			forward = false
	else:
		i -= 1
		Music.fade_sounds(Music.Fade.OUT, i)
		if i == -1:
			forward = true


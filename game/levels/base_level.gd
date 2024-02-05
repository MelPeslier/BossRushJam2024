class_name BaseLevel
extends Node2D

signal player_entered(_player : Player)
signal alternative_loop_start
signal music_loop_start
signal loop_up(_index: int)
signal loop_down(_index: int)

@export_range(-60, 0) var db_music_volume: float = 0
@export_file("*.wav") var music_intro_path: String = ""
@export_file("*.wav") var music_loop_1_path: String = ""
@export_file("*.wav") var music_loop_2_path: String = ""
@export_file("*.wav") var music_loop_3_path: String = ""

@export_file("*.wav") var alternative_music_loop_path: String = ""

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
	Parameters.hide_mouse()
	alternative_loop_start.connect( _on_alternative_loop_start )
	music_loop_start.connect( _on_music_loop_start )
	loop_up.connect( _on_loop_up )
	loop_down.connect( _on_loop_down )

	for integer: int in range( music_loop_paths.size() -1, -1, -1):
		if music_loop_paths[integer] == "":
			music_loop_paths.pop_at(integer)

	Music.db_volume = db_music_volume
	if not music_intro_path.is_empty():
		Music.change_sounds( [music_intro_path], Music.CrossFade.OUT_IN )
		Music.audio_stream_players[0].finished.connect( _on_intro_finished, CONNECT_ONE_SHOT )
	elif not music_loop_paths.is_empty():
		Music.change_sounds( music_loop_paths, Music.CrossFade.OUT_IN )

	GameState.in_game = true

	if not GameState.saved_game.level_path == level_path:
		GameState.saved_game.level_check_point_id = 0
		GameState.saved_game.level_path = level_path
		GameState.save_game()

	var player_instance :Player = player_scene.instantiate() as Player
	for_player.add_child(player_instance)
	player = player_instance
	for checkpoint: Checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		if checkpoint.id == GameState.saved_game.level_check_point_id:
			player.global_position = checkpoint.global_position - Vector2(0, player.my_collision_shape.shape.get_rect().size.y)
			player.terrain_detector.last_ground_tile_position = player.global_position
			break

	for ep: EnvironementParticles in particles.get_children():
		ep.player = player

	player_entered.emit(player)


func _on_intro_finished() -> void:
	if music_loop_paths.is_empty(): return
	Music.change_sounds(music_loop_paths, Music.CrossFade.NONE)


func _on_alternative_loop_start() -> void:
	Music.change_sounds([alternative_music_loop_path], Music.CrossFade.CROSS, Vector2(2, 0.5))

func _on_music_loop_start() -> void:
	if music_loop_paths.is_empty(): return
	Music.change_sounds(music_loop_paths, Music.CrossFade.CROSS, Vector2(7, 4))

func _on_loop_up(_index: int) -> void:
	pass

func _on_loop_down(_index: int) -> void:
	pass






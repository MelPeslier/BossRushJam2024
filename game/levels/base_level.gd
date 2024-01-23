class_name BaseLevel
extends Node2D

@export var player: Player

@export_file("*.wav") var music_intro_path: String
@export_file("*.wav") var music_loop_1_path: String
@export_file("*.wav") var music_loop_2_path: String
@export_file("*.wav") var music_loop_3_path: String

@onready var music_loop_paths: Array[String] = [music_loop_1_path, music_loop_2_path, music_loop_3_path]

var i: int = 0;
var forward:= true

static var level: BaseLevel = null

@export var stuff_2d: Node2D
@export var tile_map: TileMap


func _ready() -> void:
	level = self

	Music.change_sounds( [music_intro_path], Music.CrossFade.CROSS )
	Music.audio_stream_players[0].finished.connect( _on_intro_finished, CONNECT_ONE_SHOT )
	GameState.in_game = true
	for checkpoint: Checkpoint in get_tree().get_nodes_in_group("checkpoint"):
		if checkpoint.id == GameState.saved_game.level_check_point_id:
			player.global_position = checkpoint.global_position - Vector2(0, player.my_collision_shape.shape.get_rect().size.y)


func _on_intro_finished() -> void:
	Music.change_sounds(music_loop_paths, Music.CrossFade.NONE)

# TODO DELETE : ONLY for testing
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("up"):
		_on_loop_finished()

	if Input.is_action_just_pressed("down"):
		Music.change_sounds( [music_intro_path], Music.CrossFade.NONE )


func _on_loop_finished() -> void:
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


#region *** TileData ***

#endregion

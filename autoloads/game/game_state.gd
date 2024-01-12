extends Node

var in_game := false
var in_cinematic := false

var saved_game: GameSave

func _ready() -> void:
	saved_game = GameSave.load_or_create()


func has_saved_game() -> bool:
	return saved_game.level == 0


func save_game() -> void:
	saved_game.save()


func erase_game() -> void:
	pass


func new_game() -> void:
	saved_game = GameSave.reset()


func can_pause() -> bool:
	return not in_cinematic

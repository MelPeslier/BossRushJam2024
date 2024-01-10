extends Node

var in_game := false
var in_credits := false


func save_game() -> void:
	pass


func erase_game() -> void:
	pass


func can_pause() -> bool:
	return not in_credits

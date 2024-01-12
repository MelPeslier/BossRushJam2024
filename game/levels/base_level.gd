class_name BaseLevel
extends Node2D

@export var limits: Array[Vector2i] = [Vector2i(0, 1920) , Vector2i(-1400, 0)]
@export var player: Player

func _ready() -> void:
	GameState.in_game = true
	player.camera.limit_left = limits[0].x
	player.camera.limit_right = limits[0].y
	player.camera.limit_top = limits[1].x
	player.camera.limit_bottom = limits[1].y

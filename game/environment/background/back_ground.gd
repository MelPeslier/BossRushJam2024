class_name MyBackground
extends Node2D

@export var level: BaseLevel
@export var left: float = 0
@export var right: float = 1
@export var top: float = 1
@export var bot: float = 0

@export var background_images: Array[Sprite2D]
#@export var background_scroll_coefs: Array[float]

var offset_limits: Array[Vector2] = []
var player : Player
var coef := Vector2.ZERO
var screen := Vector2( 1920.0, 1080.0 )

func _ready() -> void:
	level.player_entered.connect( _on_player_entered )
	set_process(false)

	for i: int in background_images.size():
		var img := background_images[i]
		var tex_size = img.get_rect().size * img.scale
		print("img.get_rect().size : ", img.get_rect().size)
		offset_limits.append( (tex_size * 0.6 - screen ) * 0.5  )


func _process(delta: float) -> void:
	if not player:
		set_process(false)
		return

	coef.x = clampf( remap(player.global_position.x, left, right, 1, -1), -1, 1 )
	coef.y = clampf( remap(player.global_position.y, top, bot, 1, -1), -1, 1 )

	global_position = player.global_position

	var _camera := get_viewport().get_camera_2d()
	var _camera_margin := Vector2(maxf(_camera.drag_left_margin, _camera.drag_right_margin), maxf(_camera.drag_bottom_margin, _camera.drag_top_margin) )
	_camera_margin *= screen
	print("camera margin : ", _camera_margin)
	for i: int in background_images.size():
		var img := background_images[i]
		var limit := offset_limits[i]
		img.offset = (limit ) * coef
	10.6719



func _on_player_entered(_player: Player) -> void:
	player = _player
	set_process(true)

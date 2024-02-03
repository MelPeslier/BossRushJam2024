class_name FlashEffect
extends Node

const P_COEF: String = "material:shader_parameter/coef"
const P_COLOR: String = "material:shader_parameter/color"

@export var node : Node2D

@export var color := Color.WHITE
@export var normal_coef_time: Array[float] = [
	1.0, 0.08,
	0.0, 0.16,
]
@export var twice_coef_time: Array[float] = [
	1.0, 0.08,
	0.5, 0.08,
	1.0, 0.08,
	0.0, 0.16,
]

@onready var shader_mat = preload("res://shared/materials/flash/flash.tres")
var old_mat = null
var tween: Tween = null

func flash( _coef_time: Array[float] , _color := Color.WHITE, _trans := Tween.TRANS_LINEAR, _ease := Tween.EASE_OUT_IN) -> void:
	if tween and tween.is_running():
		node.material = old_mat
		tween.kill()
	old_mat = node.material
	node.material = shader_mat.duplicate()
	tween = create_tween().set_trans(_trans).set_ease(_ease)
	tween.tween_property(node, P_COLOR, _color, 0)
	# time -> value  ...
	for i: int in range(0, _coef_time.size(), 2):
		tween.tween_property(node, P_COEF, _coef_time[i], _coef_time[i+1])
	tween.tween_property(node, "material", old_mat, 0)


func flash_normal() -> void:
	flash(normal_coef_time, color)


func flash_twice() -> void:
	flash(twice_coef_time, color)

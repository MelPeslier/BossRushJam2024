class_name FlashEffect
extends Node

const P_COEF: String = "material:shader_parameter/coef"
const P_COLOR: String = "material:shader_parameter/color"

@export var node : Node2D
@onready var flash_mat = preload("res://shared/materials/flash/flash.tres")

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

var tween: Tween = null

func flash( _coef_time: Array[float] , _color := Color.WHITE, _trans := Tween.TRANS_LINEAR, _ease := Tween.EASE_OUT_IN) -> void:
	node.material = flash_mat
	var mat: ShaderMaterial = node.material as ShaderMaterial
	mat.resource_local_to_scene = true
	mat.set_shader_parameter(P_COLOR, _color)

	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_trans(_trans).set_ease(_ease)

	# time -> value  ...
	for i: int in range(0, _coef_time.size(), 2):
		tween.tween_property(node, P_COEF, _coef_time[i], _coef_time[i+1])


func flash_normal() -> void:
	flash(normal_coef_time, color)


func flash_twice() -> void:
	flash(twice_coef_time, color)

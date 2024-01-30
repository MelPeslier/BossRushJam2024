class_name TransitionScreen
extends CanvasLayer

@export var root_node: Control

var tween: Tween
var tween_time: float = 0 : set = _set_tween_time

func _ready() -> void:
	root_node.visible = false
	root_node.modulate.a = 0


func appear(_time: float) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()

	tween.tween_property(root_node, "visible", true, 0.01)
	tween.tween_method(_set_tween_time, tween_time, _time, _time)
	tween.parallel().tween_property(root_node, "modulate:a", 1, _time)


func disappear(_time: float) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()

	tween.tween_method(_set_tween_time, tween_time, 0, _time)
	tween.parallel().tween_property(root_node, "modulate:a", 0, _time)
	tween.tween_property(root_node, "visible", false, 0.01)


func _set_tween_time(_time: float) -> void:
	tween_time = _time

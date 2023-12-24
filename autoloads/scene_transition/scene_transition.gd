extends CanvasLayer

@export var animator: AnimationPlayer

var thread: Thread

@onready var control_root: Control = $ControlRoot


func change_scene(_target_path: String) -> void:
	control_root.mouse_filter = Control.MOUSE_FILTER_STOP
	animator.play("appear")
	await animator.animation_finished
	get_tree().change_scene_to_file(_target_path)


	animator.play("disappear")
	control_root.mouse_filter = Control.MOUSE_FILTER_IGNORE

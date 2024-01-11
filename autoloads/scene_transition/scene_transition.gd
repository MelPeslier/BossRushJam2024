extends CanvasLayer

@export var animator: AnimationPlayer

var thread: Thread
var _scene_path: String = ""


@onready var control_root: Control = $ControlRoot

func _ready() -> void:
	set_process(false)
	visible = false


func change_scene(_target_path: String) -> void:
	control_root.mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true
	_scene_path = _target_path
	animator.play("appear")
	ResourceLoader.load_threaded_request( _target_path )
	set_process(true)


func _process(_delta: float) -> void:
	var status = get_status()
	var progress = get_progress()
	match(status):
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			disappear()
		ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			if animator.is_playing():
				await animator.animation_finished
			change_scene_to_resource()
			disappear()


func get_status() -> ResourceLoader.ThreadLoadStatus:
	return ResourceLoader.load_threaded_get_status( _scene_path )


func get_progress() -> ResourceLoader.ThreadLoadStatus:
	var progress_array : Array = []
	ResourceLoader.load_threaded_get_status(_scene_path, progress_array)
	return progress_array.pop_back()


func get_resource():
	var current_loaded_resource = ResourceLoader.load_threaded_get(_scene_path)
	return current_loaded_resource


func change_scene_to_resource() -> void:
	var err = get_tree().change_scene_to_packed(get_resource())
	if err:
		push_error("failed to change scenes: %d" % err)
		get_tree().quit()


func disappear() -> void:
	control_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	animator.play("disappear")
	await animator.animation_finished
	visible = false

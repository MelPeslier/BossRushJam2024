extends CanvasLayer

@export var animator: AnimationPlayer
@export var bg: ColorRect

var thread: Thread
var _scene_path: String = ""
var progress: float: set = _set_progress
var progress_tween: Tween
@export var fill_speed: float = 2


@onready var control_root: Control = $ControlRoot

func _ready() -> void:
	set_process(false)
	visible = false


func change_scene(_target_path: String) -> void:
	GameState.in_cinematic = true
	control_root.mouse_filter = Control.MOUSE_FILTER_STOP
	visible = true
	_scene_path = _target_path
	progress = 0
	animator.play("appear")
	ResourceLoader.load_threaded_request( _target_path )
	set_process(true)


func _process(_delta: float) -> void:
	var status = get_status()
	if progress_tween and progress_tween.is_running():
		progress_tween.kill()
	progress_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	progress_tween.tween_property(self, "progress", get_progress(), fill_speed)

	match(status):
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			disappear()
		ResourceLoader.THREAD_LOAD_LOADED:
			if animator.is_playing():
				await animator.animation_finished
			progress_tween.tween_callback( change_scene_to_resource )
			progress_tween.tween_callback( disappear )
			set_process(false)


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
	GameState.in_cinematic = false
	visible = false


func _set_progress(_progress: float) -> void:
	progress = _progress
	var mat: ShaderMaterial = bg.material as ShaderMaterial
	mat.set_shader_parameter("progress", progress)

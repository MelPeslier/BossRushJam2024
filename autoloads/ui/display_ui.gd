extends CanvasLayer

@export var framerate: Label
@export var framerate_timer: Timer


func show_framerate(_show: bool) -> void:
	framerate.visible = _show
	_on_framerate_timer_timeout()
	if _show:
		framerate_timer.start()
	else:
		framerate_timer.stop()

func _on_framerate_timer_timeout() -> void:
	var fps := int( Engine.get_frames_per_second() )
	framerate.text = str( fps )


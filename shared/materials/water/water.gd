@tool
extends Sprite2D

func _ready() -> void:
	GameEvents.zoom_changed.connect( _on_zoom_changed )
	_on_zoom_changed()
	_on_item_rect_changed()
	#TODO connecter la caméra à ce script
	return


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_on_zoom_changed()
	else:
		set_process(false)


func _on_zoom_changed():
	var mat: ShaderMaterial = material as ShaderMaterial
	mat.set_shader_parameter("y_zoom", get_viewport_transform().get_scale().y )


func _on_item_rect_changed() -> void:
	var mat: ShaderMaterial = material as ShaderMaterial
	mat.set_shader_parameter("scale", scale)

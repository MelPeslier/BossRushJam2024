@tool
extends Sprite2D

func _ready() -> void:
	GameEvents.zoom_changed.connect( _on_zoom_changed )
	_on_zoom_changed()
	_on_item_rect_changed()


func _on_zoom_changed():
	var mat: ShaderMaterial = material as ShaderMaterial
	mat.set_shader_parameter("y_zoom", get_viewport_transform().get_scale().y )


func _on_item_rect_changed() -> void:
	var mat: ShaderMaterial = material as ShaderMaterial
	mat.set_shader_parameter("scale", scale)

class_name GUI_Spell
extends TextureRect

var _is_activated := false


func show_possible() -> void:
	if not _is_activated:
		modulate = Color.YELLOW
		_is_activated = true


func hide_possible() -> void:
	if _is_activated:
		modulate = Color.WHITE
		_is_activated = false

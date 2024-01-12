extends Node2D

func _ready() -> void:
	GameEvents.toggle_tutorial.connect( _on_toggle_tutorial_changed )


func _on_toggle_tutorial_changed(_toggled_on: bool) -> void:
	visible = _toggled_on

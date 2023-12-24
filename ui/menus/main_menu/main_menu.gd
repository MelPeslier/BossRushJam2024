extends Control

@export_file("*.tscn") var target_scene_path : String


func _on_mouse_entered() -> void:
	Sfx.play_ui(Sfx.ui_over)



func _on_play_button_down() -> void:
	Sfx.play_ui(Sfx.ui_play)
	if target_scene_path:
		SceneTransition.change_scene(target_scene_path)


func _on_quit_button_down() -> void:
	Sfx.play_ui(Sfx.ui_cancel)


func _on_credits_button_down() -> void:
	Sfx.play_ui(Sfx.ui_press)


func _on_parameters_button_down() -> void:
	Sfx.play_ui(Sfx.ui_press)

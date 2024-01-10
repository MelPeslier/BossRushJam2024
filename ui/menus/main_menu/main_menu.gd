extends Control

@export_file("*.tscn") var target_scene_path : String = "res://game/levels/main_level.tscn"

@export var credits_canvas_layer: CreditCanvasLayer


func _on_mouse_entered() -> void:
	Sfx.play_ui(Sfx.ui_over)


func _on_play_button_down() -> void:
	Sfx.play_ui(Sfx.ui_play)
	if target_scene_path:
		SceneTransition.change_scene(target_scene_path)


func _on_quit_button_down() -> void:
	Sfx.play_ui(Sfx.ui_cancel)
	get_tree().quit()


func _on_credits_button_down() -> void:
	Sfx.play_ui(Sfx.ui_press)
	credits_canvas_layer.show_content()


func _on_parameters_button_down() -> void:
	Sfx.play_ui(Sfx.ui_press)

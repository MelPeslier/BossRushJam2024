extends Control

@export var credits_canvas_layer: CreditCanvasLayer
@export var buttons_container: VBoxContainer


func _ready() -> void:
	for button: MyButton in buttons_container.get_children():
		if button.visible:
			button.grab_focus()
			return


func _on_continue_button_down() -> void:
	pass


func _on_new_game_button_down() -> void:
	GameState.new_game()
	SceneTransition.change_scene( GameState.saved_game.level_path )


func _on_quit_button_down() -> void:
	get_tree().quit()


func _on_credits_button_down() -> void:
	credits_canvas_layer.show_content()


func _on_parameters_button_down() -> void:
	Parameters.pause_game()


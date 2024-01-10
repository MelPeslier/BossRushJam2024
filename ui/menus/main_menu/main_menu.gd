extends Control

@export var credits_canvas_layer: CreditCanvasLayer
@export var play: MyButton


func _on_continue_button_down() -> void:
	pass # Replace with function body.


func _on_new_game_button_down() -> void:
	GameState.new_game()
	SceneTransition.change_scene( GameState.saved_game.level_path )


func _on_quit_button_down() -> void:
	get_tree().quit()


func _on_credits_button_down() -> void:
	credits_canvas_layer.show_content()


func _on_parameters_button_down() -> void:
	Parameters.pause_game()


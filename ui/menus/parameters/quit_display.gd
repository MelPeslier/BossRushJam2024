class_name QuitDisplay extends Control

enum Type {
	RETURN,
	ABANDON
}

const menu_path: String = "res://ui/menus/main_menu/main_menu.tscn"

var type: Type

@export var choice: ControlChoice


func _ready() -> void:
	visible = false
	choice.back_button.button_down.connect( _on_back_button_button_down )
	choice.continue_button.button_down.connect( _on_continue_button_button_down )


func show_content(_type : Type) -> void:
	type = _type
	match type:
		Type.RETURN:
			choice.title_label.text = "BACK_TO_MENU"
			choice.content_label.text = "BACK_TO_MENU_CONTENT"
			choice.continue_button.grab_focus()

		Type.ABANDON:
			choice.title_label.text = "ABANDON"
			choice.content_label.text = "ABANDON_CONTENT"
			choice.back_button.grab_focus()

	visible = true


func hide_content() -> void:
	visible = false
	Parameters.previous_button.grab_focus()


func _on_back_button_button_down() -> void:
	hide_content()


func _on_continue_button_button_down() -> void:
	SceneTransition.change_scene(menu_path)
	match type:
		Type.RETURN:
			GameState.save_game()
		Type.ABANDON:
			GameState.erase_game()

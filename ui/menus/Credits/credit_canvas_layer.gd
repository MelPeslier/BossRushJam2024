class_name CreditCanvasLayer
extends CanvasLayer

@onready var back: MyButton = $Control/Back


func _ready() -> void:
	hide_content()


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("back"):
		hide_content()
		get_viewport().set_input_as_handled()



func show_content() -> void:
	GameState.in_menu = true
	visible = true
	set_process_unhandled_input(true)
	back.disabled = false


func hide_content() -> void:
	GameState.in_menu = false
	visible = false
	back.disabled = true
	set_process_unhandled_input(false)


func _on_back_button_down() -> void:
	hide_content()

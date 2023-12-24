extends Control
@onready var display_server: MenuButton = $VBoxContainer/DisplayServer
var resolutions: Array[Vector2i] = [
	Vector2i( 3840, 1080 ),
	Vector2i( 1920, 1080 ),
]


func _on_os_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _ready() -> void:
	display_server.get_popup().id_pressed.connect( _on_menu_item_selected )
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_menu_item_selected(id: int) -> void:
	DisplayServer.window_set_size(resolutions[id])



func _on_project_settings_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_size(Vector2i(1600, 800))
	else:
		DisplayServer.window_set_size(Vector2i(1920, 1080))




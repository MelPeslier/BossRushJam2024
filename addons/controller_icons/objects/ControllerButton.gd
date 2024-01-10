@tool
class_name ControllerButton
extends Button

@export var path : String = "":
	set(_path):
		path = _path
		if is_inside_tree():
			if force_type > 0:
				icon = ControllerIcons.parse_path(path, force_type - 1)
			else:
				icon = ControllerIcons.parse_path(path)

@export_enum("Both", "Keyboard/Mouse", "Controller") var show_only : int = 0:
	set(_show_only):
		show_only = _show_only
		_on_input_type_changed(ControllerIcons._last_input_type)

@export_enum("None", "Keyboard/Mouse", "Controller") var force_type : int = 0:
	set(_force_type):
		force_type = _force_type
		_on_input_type_changed(ControllerIcons._last_input_type)

@export_category("Audio")
@export var ui_focused := SoundList.Ui.FOCUSSED
@export var ui_pressed := SoundList.Ui.PRESSED


func _ready():
	ControllerIcons.input_type_changed.connect(_on_input_type_changed)
	self.path = path
	mouse_entered.connect( _on_mouse_entered )
	focus_entered.connect( _on_focus_entered )
	button_down.connect( _on_button_down )

func _on_input_type_changed(input_type):
	if show_only == 0 or \
		(show_only == 1 and input_type == ControllerIcons.InputType.KEYBOARD_MOUSE) or \
		(show_only == 2 and input_type == ControllerIcons.InputType.CONTROLLER):
		self.path = path
	else:
		icon = null

func get_tts_string() -> String:
	if force_type:
		return ControllerIcons.parse_path_to_tts(path, force_type - 1)
	else:
		return ControllerIcons.parse_path_to_tts(path)


#region *** Audio ***
func _on_mouse_entered() -> void:
	grab_focus()

func _on_focus_entered() -> void:
	Sfx.play_ui( ui_focused )

func _on_button_down() -> void:
	Sfx.play_ui( ui_pressed )
#endregion

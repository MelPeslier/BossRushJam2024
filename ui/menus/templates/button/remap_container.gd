class_name RemapContainer
extends HBoxContainer


var action_name: String

static var user_controls_prefs: UserControlsPreferences

@onready var remap_label: Label = $RemapLabel
@onready var remap_button: ControllerButton = $RemapButton


func _ready() -> void:
	set_process_unhandled_input(false)
	remap_label.text = action_name.to_upper()
	remap_button.path = action_name


func _on_remap_button_toggled(toggled_on: bool) -> void:
	set_process_unhandled_input(toggled_on)
	if toggled_on:
		remap_button.icon = null
		remap_button.text = "... AWAITING_INPUT ..."
		remap_button.release_focus()
	else:
		#update_key_text()
		remap_button.text = ""
		remap_button.path = action_name
		remap_button.grab_focus()


func _unhandled_input(_event: InputEvent) -> void:
	var input_type = null
	match _event.get_class():
		"InputEventKey", "InputEventMouseButton":
			input_type = ControllerIcons.InputType.KEYBOARD_MOUSE
		"InputEventMouseMotion":
			if ControllerIcons._settings.allow_mouse_remap and _event.velocity.length() > ControllerIcons._settings.mouse_min_movement:
				input_type = ControllerIcons.InputType.KEYBOARD_MOUSE
		"InputEventJoypadButton":
			input_type = ControllerIcons.InputType.CONTROLLER
		"InputEventJoypadMotion":
			if abs(_event.axis_value) > ControllerIcons._settings.joypad_deadzone:
				input_type = ControllerIcons.InputType.CONTROLLER

	if input_type == null:
		return

	# Call the function to actualise the user preferences and change the game input map
	var replaced_action: String = user_controls_prefs.change_and_replace(action_name, _event)
	# If the key was existing we update the older key (only the icon, as the changes have been made in the previous function)
	if not replaced_action.is_empty() and not replaced_action == "not_allowed":
		for _remap_button: ControllerButton in Parameters.remap_buttons:
			if _remap_button.path == replaced_action:
				_remap_button.path = replaced_action
				print("\n\n\n _remap_button.path : ", replaced_action)
	remap_button.button_pressed = false


#func update_key_text() -> void:
	#var _text: String = ""
	#_text = InputMap.action_get_events(action_name)[0].as_text()
	#_text.trim_suffix(" (Physical)")
	#remap_button.text = "%s" % _text


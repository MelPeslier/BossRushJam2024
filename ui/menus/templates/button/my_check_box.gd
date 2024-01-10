class_name MyCheckBox
extends CheckBox

@export_category("Audio")
@export var ui_focused := SoundList.Ui.FOCUSSED
@export var ui_checked_on := SoundList.Ui.CHECKED_ON
@export var ui_checked_off := SoundList.Ui.CHECKED_OFF


func _ready() -> void:
	mouse_entered.connect( _on_mouse_entered )
	focus_entered.connect( _on_focus_entered )
	toggled.connect( _on_toggled )

func _on_mouse_entered() -> void:
	grab_focus()

func _on_focus_entered() -> void:
	Sfx.play_ui( ui_focused )

func _on_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		Sfx.play_ui(ui_checked_on)
	else:
		Sfx.play_ui(ui_checked_off)

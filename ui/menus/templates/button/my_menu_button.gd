class_name MyMenuButton
extends MenuButton

@export_category("Audio")
@export var ui_focused := SoundList.Ui.FOCUSSED
@export var ui_pressed := SoundList.Ui.PRESSED


func _ready() -> void:
	mouse_entered.connect( _on_mouse_entered )
	focus_entered.connect( _on_focus_entered )
	button_down.connect( _on_button_down )
	get_popup().id_focused.connect( _on_popup_id_focused )
	get_popup().id_pressed.connect( _on_popup_id_pressed )

func _on_mouse_entered() -> void:
	grab_focus()

func _on_focus_entered() -> void:
	Sfx.play_ui( ui_focused )

func _on_button_down() -> void:
	Sfx.play_ui( ui_pressed )

func _on_popup_id_focused(_id: int) -> void:
	Sfx.play_ui( ui_focused )

func _on_popup_id_pressed(_id: int) -> void:
	Sfx.play_ui( ui_pressed )


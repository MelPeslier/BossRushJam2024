extends Node


@export_group("UI", "ui_")
@export var ui_bus_name : String = "UI"
@export var ui_play: AudioStream
@export var ui_over: AudioStream
@export var ui_press: AudioStream
@export var ui_cancel: AudioStream
@export var ui_reset: AudioStream
@export var ui_slide: AudioStream
@export var ui_checked_on: AudioStream
@export var ui_checked_off: AudioStream

@onready var asp := AudioStreamPlayer.new()


func _play(_audio_stream: AudioStream, _bus_name: String) -> void:
	var _asp := asp.duplicate()
	_asp.stream = _audio_stream
	_asp.bus = _bus_name
	_asp.finished.connect(_on_play_finished.bind(_asp))
	add_child(_asp)
	_asp.play()


func _on_play_finished(_asp: AudioStreamPlayer) -> void:
	_asp.queue_free()


#region UI

func play_ui(_audio_stream: AudioStream) -> void:
	if not _audio_stream: return
	_play(_audio_stream, ui_bus_name)

#
#func play_other(_audio_stream: AudioStream, _bus: String = other_bus) -> void:
	#_play(asp_other, _audio_stream, _bus)


func on_slider_value_changed(_new_val: float) -> void:
	play_ui(ui_slide)


func on_check_box_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		play_ui(ui_checked_on)
	else:
		play_ui(ui_checked_off)


func on_mouse_entered() -> void:
	play_ui(ui_over)


func on_button_down() -> void:
	play_ui(ui_press)


#endregion


extends Node

@onready var ui_play: AudioStreamPlayer = $Play
@onready var ui_over: AudioStreamPlayer = $Over
@onready var ui_press: AudioStreamPlayer = $Press
@onready var ui_cancel: AudioStreamPlayer = $Cancel
@onready var ui_reset: AudioStreamPlayer = $Reset
@onready var ui_slide: AudioStreamPlayer = $Slide
@onready var ui_checked_on: AudioStreamPlayer = $CheckedOn
@onready var ui_checked_off: AudioStreamPlayer = $CheckedOff


func _play(_audio_stream_player: AudioStreamPlayer) -> void:
	var _asp := _audio_stream_player.duplicate()
	_asp.finished.connect(_on_play_finished.bind(_asp))
	add_child(_asp)
	_asp.play()


func _on_play_finished(_asp: AudioStreamPlayer) -> void:
	_asp.queue_free()


#region UI

func play_ui(_audio_stream_player: AudioStreamPlayer) -> void:
	if not _audio_stream_player: return
	_play(_audio_stream_player)

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


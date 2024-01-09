class_name MyAudioParams
extends HBoxContainer

const MUTE_THRESHOLD: float = 0.03

var bus_index: int

@onready var label: Label = $Label
@onready var slider: HSlider = $Slider

var _old_val: float
var parameters: Parameters

func _ready() -> void:
	update_params()

	slider.value_changed.connect(_on_slider_value_changed)
	slider.value_changed.connect(Sfx.on_slider_value_changed)
	slider.mouse_entered.connect(Sfx.on_mouse_entered)


func _on_slider_value_changed(_new_val: float) -> void:
	if _old_val == _new_val: return
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(_new_val)
	)
	if _new_val < MUTE_THRESHOLD :
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
	_old_val = _new_val
	parameters.user_audio_prefs.volumes[bus_index] = _new_val
	parameters.user_audio_prefs.save()


func update_params() -> void:
	slider.value = db_to_linear( AudioServer.get_bus_volume_db(bus_index) )
	_old_val = slider.value
	if slider.value < MUTE_THRESHOLD :
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)

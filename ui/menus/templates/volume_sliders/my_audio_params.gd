class_name MyAudioParams
extends HBoxContainer

var bus_index: int

@onready var label: Label = $Label
@onready var check_box: CheckBox = $CheckBox
@onready var slider: HSlider = $Slider


func _ready() -> void:
	slider.value = db_to_linear( AudioServer.get_bus_volume_db(bus_index) )
	slider.value_changed.connect(_on_slider_value_changed)
	slider.value_changed.connect(Sfx.on_slider_value_changed)
	slider.mouse_entered.connect(Sfx.on_mouse_entered)

	check_box.toggled.connect(_on_check_box_toggled)
	check_box.toggled.connect(Sfx.on_check_box_toggled)
	check_box.mouse_entered.connect(Sfx.on_mouse_entered)


func _on_slider_value_changed(_new_val: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(_new_val)
	)


func _on_check_box_toggled(_toggled_on: bool) -> void:
	AudioServer.set_bus_mute(bus_index, _toggled_on)

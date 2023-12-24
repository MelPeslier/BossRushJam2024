extends Node


@export_group("Step", "step")
@export var step_bus_name : String = "Sfx"
@export var step_dirt: AudioStream
@export var step_grass: AudioStream
@export var step_stone: AudioStream
@export var step_sand: AudioStream
@export var step_snow: AudioStream

@onready var asp := AudioStreamPlayer2D.new() as AudioStreamPlayer2D


func _play(_audio_stream: AudioStream, _parent: Variant, _sound_data := SoundData.new(), _bus_name: String = "Master") -> void:
	var _asp := asp.duplicate() as AudioStreamPlayer2D
	_asp.stream = _audio_stream
	_asp.attenuation = _sound_data.attenuation
	_asp.max_distance = _sound_data.max_distance
	_asp.bus = _bus_name
	_asp.finished.connect(_on_play_finished.bind(_asp))

	if _parent is Vector2:
		get_window().add_child(_asp)
		var pos: Vector2 = _parent as Vector2
		_asp.global_position = pos
		print("type_vector")
	elif _parent is Node2D:
		_parent.add_child(_asp)
		print("node2D")

	_asp.play()


func _on_play_finished(_asp: AudioStreamPlayer2D) -> void:
	_asp.queue_free()


#region Step

func play_step(_audio_stream: AudioStream, _parent: Variant, _sound_data := SoundData.new(), _bus_name: String = step_bus_name) -> void:
	_play(_audio_stream, _parent, _sound_data, _bus_name)

#
#func play_other(_audio_stream: AudioStream, _bus: String = other_bus) -> void:
	#_play(asp_other, _audio_stream, _bus)

#endregion


extends Node


@export var metal_sounds: Array[AudioStreamPlayer2D]


func _play(_audio_stream_player: AudioStreamPlayer2D, _parent: Variant) -> void:
	var _asp := _audio_stream_player.duplicate() as AudioStreamPlayer2D
	_asp.finished.connect(_on_play_finished.bind(_asp))

	if _parent is Vector2:
		get_window().add_child(_asp)
		var pos: Vector2 = _parent as Vector2
		_asp.global_position = pos
		print("type_vector")
	elif _parent is Node2D:
		_parent.add_child(_asp)
		_asp.global_position = _parent.global_position
		print("node2D")

	_asp.play()


func _on_play_finished(_asp: AudioStreamPlayer2D) -> void:
	_asp.queue_free()


#region Step

func play_metal(_metal: SoundList.Metal, _parent: Variant) -> void:
	var _audio_stream_player: AudioStreamPlayer2D = metal_sounds[_metal]
	if not _audio_stream_player: return
	_play(_audio_stream_player, _parent)


extends GPUParticles2D


@onready var hit: AudioStreamPlayer2D = $Hit



func _ready() -> void:
	emitting = true
	hit.play()


func _on_finished() -> void:
	queue_free()

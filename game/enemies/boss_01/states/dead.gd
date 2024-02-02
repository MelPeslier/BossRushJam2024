extends MoveState

@export var collision_shapes: Array[CollisionShape2D]

func enter() -> void:
	super()
	for collision_shape: CollisionShape2D in collision_shapes:
		collision_shape.set_deferred("disabled", true)
	GameEvents.boss_killed.emit(parent.global_position)
	Music.fade_sounds(Music.Fade.OUT, 0, Vector2(0, 2))


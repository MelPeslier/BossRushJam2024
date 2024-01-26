extends MoveState
@onready var collision_shape_2d: CollisionShape2D = $"../../HurtboxComponent/CollisionShape2D"


func enter() -> void:
	super()
	collision_shape_2d.set_deferred("disabled", true)
	animated_sprite.animation_finished.connect( _on_animaiton_finished, CONNECT_ONE_SHOT )


func _on_animaiton_finished() -> void:
	var tween: Tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_property(animated_sprite, "modulate:a", 0.0, 1.0)
	tween.tween_callback(parent.queue_free)


func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	do_walk_decelerate(delta)
	do_gravity(delta)

	parent.apply_floor_snap()
	parent.move_and_slide()
	return null

func process_frame(_delta: float) -> State:
	return null

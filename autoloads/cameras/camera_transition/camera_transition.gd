extends Node

signal transition_finished

@onready var camera2D := Camera2D.new()

var tween: Tween

func _ready() -> void:
	camera2D.enabled = false
	add_child(camera2D)

func switch_camera2D(from: Camera2D, to: Camera2D) -> void:
	to.enabled = true
	to.make_current()
	from.enabled = false

func transition_camera2D(from: Camera2D, to: Camera2D, duration: float = 1.0, _trans := Tween.TRANS_CUBIC, _ease := Tween.EASE_IN_OUT) -> void:
	if not from:
		from = get_viewport().get_camera_2d()
	if not from:
		push_error("no active camera")
		return
	#TODO Remplacer ce booléen par juste déplacer la caméra depuis celle actuelle avec la nouvelle
	camera2D.zoom = from.zoom
	camera2D.offset = from.offset
	camera2D.light_mask = from.light_mask
	camera2D.global_transform = from.global_transform
	camera2D.global_position = from.get_screen_center_position()

	# Move our transition camera to the first camera position

	# Make our transition camera current
	camera2D.enabled = true
	camera2D.make_current()
	from.enabled = false

	# Move to the second camera, while also adjusting the parameters to
	# match the second camera
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(camera2D, "global_transform", to.global_transform, duration)\
	.set_trans(_trans).set_ease(_ease)
	tween.parallel().tween_property(camera2D, "zoom", to.zoom, duration)\
	.set_trans(_trans).set_ease(_ease)
	tween.parallel().tween_property(camera2D, "offset", to.offset, duration)\
	.set_trans(_trans).set_ease(_ease)

	# Make the second camera current
	tween.tween_property(to, "enabled", true, 0)
	tween.tween_callback(to.make_current)
	tween.tween_property(camera2D, "enabled", false, 0)
	tween.tween_callback(camera_swiched)


func camera_swiched() -> void:
	transition_finished.emit()

class_name PlayerInteractorComponent
extends InteractorComponent

@export var player: Player

var cached_closest: InteractableComponent


func _ready() -> void:
	area_exited.connect(_on_area_exited)
	parent = player


func process_physics(_delta: float) -> void:
	var new_closest: InteractableComponent = get_closest_interactable()
	if new_closest != cached_closest:
		if is_instance_valid(cached_closest):
			unfocus(cached_closest)
		if new_closest:
			focus(new_closest)
	cached_closest = new_closest


func process_unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		if is_instance_valid(cached_closest):
			interact(cached_closest)


func _on_area_exited(_area: InteractableComponent) -> void:
	if cached_closest == _area:
		unfocus(_area)


func reset_cached_closest() -> void:
	cached_closest = null

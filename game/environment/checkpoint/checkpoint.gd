class_name Checkpoint
extends Node2D
static var ids: int = -1
static var last_id: int = -1
static var last_checkpoint: Checkpoint = null
@export var id: int = 0

@export var collision_shape: CollisionShape2D
@export var gpu_particles: GPUParticles2D
@export var animated_sprite: AnimatedSprite2D


func _ready() -> void:
	ids += 1
	id = ids

	if last_id == -1:
		last_id = GameState.saved_game.level_check_point_id

	gpu_particles.emitting = false

	if GameState.saved_game.level_check_point_id == id:
		_activate()
	elif id < last_id:
		_deactivate()
	else:
		collision_shape.disabled = false



func _activate() -> void:
	collision_shape.disabled = true
	gpu_particles.amount_ratio = 1.0
	gpu_particles.emitting = true
	GameState.saved_game.level_check_point_id = id
	GameState.save_game()
	last_id = id
	animated_sprite.play("open")

	if last_checkpoint:
		last_checkpoint._deactivate()
	last_checkpoint = self


func _deactivate() -> void:
	gpu_particles.emitting = false
	gpu_particles.amount_ratio = 0.0
	collision_shape.disabled = true
	animated_sprite.play_backwards("open")



func _on_interactable_component_focused(_interactor: InteractorComponent) -> void:
	_activate()

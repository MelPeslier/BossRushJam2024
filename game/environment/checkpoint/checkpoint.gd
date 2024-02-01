class_name Checkpoint
extends Node2D


static var ids: int = -1
static var last_id: int = -1
static var last_checkpoint: Checkpoint = null
var id: int = 0

@export_file("*.tscn") var next_level_path : String
@export var collision_shape: CollisionShape2D
@export var gpu_particles: GPUParticles2D
@export var animated_sprite: AnimatedSprite2D
@onready var activate: AudioStreamPlayer2D = $Activate


func _ready() -> void:
	print(name, " is ready")
	ids += 1
	id = ids

	if last_id == -1:
		last_id = GameState.saved_game.level_check_point_id

	gpu_particles.emitting = false

	if last_id == id:
		_activate()
	elif id < last_id:
		_deactivate()
	else:
		collision_shape.disabled = false


static func reset() -> void:
	ids = -1
	last_id = -1
	last_checkpoint = null


func _exit_tree() -> void:
	Checkpoint.reset()


func _activate() -> void:
	collision_shape.disabled = true
	gpu_particles.amount_ratio = 1.0
	gpu_particles.emitting = true
	animated_sprite.play("open")

	if not next_level_path.is_empty():
		SceneTransition.change_scene(next_level_path)
		return
	GameState.saved_game.level_check_point_id = id
	GameState.save_game()
	last_id = id

	if last_checkpoint:
		last_checkpoint._deactivate()
	last_checkpoint = self


func _deactivate() -> void:
	gpu_particles.emitting = false
	gpu_particles.amount_ratio = 0.0
	collision_shape.disabled = true
	animated_sprite.play_backwards("open")



func _on_interactable_component_focused(_interactor: InteractorComponent) -> void:
	activate.play()
	_activate()

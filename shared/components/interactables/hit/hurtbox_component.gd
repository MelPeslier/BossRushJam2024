class_name HurtboxComponent
extends Area2D

signal hit_received(_attack_data: AttackData, _dir: Vector2)

@export var parent: Node2D
@export_range(0, 10, 1) var energy_to_give: float
@onready var collision_shape: CollisionShape2D = get_child(0) as CollisionShape2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	area_shape_entered.connect(_on_area_shape_entered)

func _on_area_shape_entered(_area_rid: RID, hitbox: HitboxComponent, _area_shape_index: int, _local_shape_index: int) -> void:
	if not hitbox:
		return
	if hitbox.parent == parent:
		return

	if hitbox.energy_component and energy_to_give > 0 and hitbox.attack_data.can_gain_energy :
		hitbox.energy_component.gain(energy_to_give)


	var dir := hitbox.parent.global_position.direction_to(parent.global_position)

	hitbox.hit_gived_at.emit( hitbox.global_position )

	dir.x = 1 if dir.x > 0 else -1
	dir.y = 1 if dir.y > 0 else -1

	var attack_data := hitbox.attack_data
	hit_received.emit(attack_data, dir)


func deactivate() -> void:
	collision_shape.set_deferred("disabled", true)


func activate(time: float = 0) -> void:
	if time > 0:
		var timer := Timer.new()
		add_child(timer)
		timer.start(time)
		await timer.timeout
		timer.queue_free()
	collision_shape.disabled = false



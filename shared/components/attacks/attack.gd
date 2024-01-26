class_name Attack
extends Node2D



var parent: Node2D
var attack_data: AttackData
var attack_manager: AttackManager
var is_preparing := false
var my_name: String = ""
var energy_component: EnergyComponent

@export var animation_player: AnimationPlayer
@export var animated_sprite_2d: AnimatedSprite2D
@export var hitbox_component: HitboxComponent
@export var collision_shape_2d: CollisionShape2D


func _ready() -> void:
	attack_manager.last_attack = self
	animated_sprite_2d.visible = false
	if hitbox_component:
		hitbox_component.attack_data = attack_data
		hitbox_component.energy_component = energy_component
	for child in get_children():
		if child is Area2D:
			child.parent = parent

	start()


func start() -> void:
	animation_player.play("activate")


func init(_parent: Node2D, _attack_data: AttackData, _attack_manager: AttackManager, _name: String, _energy_component: EnergyComponent) -> void:
	parent = _parent
	attack_data = _attack_data
	attack_manager = _attack_manager
	my_name = _name
	energy_component = _energy_component


func preparing(toglged_on: bool) -> void:
	is_preparing = toglged_on


func interupt() -> void:
	if is_preparing:
		var timer := Timer.new()
		add_child(timer)
		timer.timeout.connect( _on_timer_timeout )
		timer.start(animation_player.current_animation_length - animation_player.current_animation_position)
		animation_player.call_deferred("stop")


func _on_timer_timeout() -> void:
	queue_free()

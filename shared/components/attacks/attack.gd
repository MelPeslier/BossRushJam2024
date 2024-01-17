class_name Attack
extends Node2D

@export_category("Test")
@export var testing := false

@export_category("Specificity")
@export var stick_to_parent := true
@export var attack_special_effects: AttackSpecialEffects

var parent: Node2D
var attack_data: AttackData
var attack_manager: AttackManager
var is_preparing := false
var my_name: String = ""

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var collision_shape_2d: CollisionShape2D = $HitboxComponent/CollisionShape2D


func _ready() -> void:
	set_process_unhandled_input(testing)
	if not testing:
		attack_manager.last_attack = self
	else:
		add_child(Camera2D.new() )
	animated_sprite_2d.visible = testing
	hitbox_component.attack_data = attack_data
	for child in get_children():
		if child is Area2D:
			child.parent = parent
	start()


func start() -> void:
	animation_player.play("activate")
	animated_sprite_2d.visible = testing
	if testing:
		animated_sprite_2d.play("default")


func init(_parent: Node2D, _attack_data: AttackData, _attack_manager: AttackManager, _name: String) -> void:
	parent = _parent
	attack_data = _attack_data
	attack_manager = _attack_manager
	my_name = _name


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("melee_attack"):
		start()

	if Input.is_action_just_pressed("distance_attack"):
		interupt()


func preparing(toglged_on: bool) -> void:
	is_preparing = toglged_on


func interupt() -> void:
	if is_preparing:
		var timer := Timer.new()
		add_child(timer)
		timer.timeout.connect( _on_timer_timeout )
		timer.start(animation_player.current_animation_length - animation_player.current_animation_position)
		animation_player.stop()
		if testing:
			animated_sprite_2d.pause()


func _on_timer_timeout() -> void:
	if testing : return
	queue_free()

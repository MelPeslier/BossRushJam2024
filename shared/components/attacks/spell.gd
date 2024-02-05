class_name Spell
extends Node2D

@export var speed: float = 1200
@export var hits : int = 1
@export var impact_scene: PackedScene

var parent: Node2D
var attack_data: AttackData
var velocity_dir := Vector2.RIGHT
var angle: float = 0

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hitbox_component.attack_data = attack_data
	hitbox_component.parent = parent
	hitbox_component.hit_gived_at.connect( _on_hitbox_component_hit_gived_at )
	velocity_dir = Vector2( cos(angle),sin(angle) ).normalized()
	rotation = angle
	animation_player.play("activate")


func _physics_process(delta: float) -> void:
	global_position += speed * delta * velocity_dir


func init(_parent : Node2D, _attack_data : AttackData, _angle: float) -> void:
	parent = _parent
	attack_data = _attack_data
	angle = _angle


func _on_hitbox_component_hit_gived_at(_pos: Vector2) -> void:
	spawn_impact(_pos)
	hits -= 1
	if hits <= 0:
		end_spell()


func spawn_impact(_pos: Vector2) -> void:
	var impact_instance: Impact = impact_scene.instantiate() as Impact
	if BaseLevel.level.stuff_2d:
		BaseLevel.level.stuff_2d.add_child(impact_instance)
	else:
		print("Spell.gd : spell added to winddow  :  ", name)
		get_window().add_child(impact_instance)

	impact_instance.global_position = _pos


func end_spell() -> void:
	#set_physics_process(false)
	hitbox_component.deactivate()
	var tween: Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 0.01)
	tween.tween_callback(queue_free)


func _on_self_destruct_timer_timeout() -> void:
	end_spell()

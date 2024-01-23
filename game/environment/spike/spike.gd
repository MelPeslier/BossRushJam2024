class_name Spike
extends StaticBody2D

enum Type {
	ALWAYS,
	MOVING,
}

enum Etat {
	DOWN,
	MIDLE,
	UP,
}

const cycles : float = 3.0


@export var hitbox_component: HitboxComponent
@export var animated_sprite: AnimatedSprite2D
@export var hit_particles_scene: PackedScene

@export var type: Type
@export var custom_speed: float = 1

@export_range(0, cycles - 1, 1) var cycle: float = 0


var cycle_time: float = 1
var start_time: float = 0
var coming_coef: float = 0.55
var damaging_coef: float = 0.85

var cycle_timer: float = 0
var start_timer: float = 0
var etat := Etat.DOWN


func _ready() -> void:
	cycle_time = Player.move_speed / 512.0 * damaging_coef
	start_time = cycle_time * remap(cycle, 0, cycles, 0, 1)
	#print(name, " : ", start_time)

	match type:
		Type.ALWAYS:
			set_physics_process(false)
			alter_spike_collisions(false)
			animated_sprite.play("to_up")
		Type.MOVING:
			alter_spike_collisions(true)
			animated_sprite.play("to_down")
			start_timer = start_time
			set_physics_process(true)



func _physics_process(delta: float) -> void:
	if start_timer > 0:
		start_timer -= delta * custom_speed
		return

	cycle_timer += delta * custom_speed
	match etat:
		Etat.DOWN:
			if cycle_timer > cycle_time * coming_coef:
				animated_sprite.play("to_midle")
				etat = Etat.MIDLE
		Etat.MIDLE:
			if cycle_timer > cycle_time * damaging_coef:
				animated_sprite.play("to_up")
				alter_spike_collisions(false)
				etat = Etat.UP
		Etat.UP:
			if cycle_timer > cycle_time:
				animated_sprite.play("to_down")
				alter_spike_collisions(true)
				cycle_timer = fmod(cycle_timer, cycle_time)
				etat = Etat.DOWN



func alter_spike_collisions(_disabled: bool) -> void:
	for shape: CollisionPolygon2D in hitbox_component.get_children():
		shape.disabled = _disabled


func _on_hitbox_component_hit_gived_at(_pos: Vector2) -> void:
	if not BaseLevel.level: return
	var instance = hit_particles_scene.instantiate() as Node2D
	BaseLevel.level.stuff_2d.add_child(instance)
	instance.global_position = _pos

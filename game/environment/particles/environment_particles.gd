@tool

extends GPUParticles2D

@export var color: Color : set = _set_color
@export var my_z_index: int = 30 : set = _set_my_z_index
@export var my_scale_max : float = 0.06 : set = _set_my_scale_max
@export var my_velocity_min : float = 100: set = _set_my_velocity_min
@export var my_velocity_max : float = 150: set = _set_my_velocity_max

static var scale_diff: float = 0.015

@export var player: Player


func _ready() -> void:
	color = color
	my_z_index = my_z_index

func _process(_delta: float) -> void:
	if player:
		position = player.position

func _set_color(_color: Color) -> void:
	color = _color
	self_modulate = color

func _set_my_z_index(_my_z_index: int) -> void:
	my_z_index = _my_z_index
	z_index = my_z_index

func _set_my_scale_max(_my_scale_max: float) -> void:
	my_scale_max = _my_scale_max
	var particles_process : ParticleProcessMaterial = process_material as ParticleProcessMaterial
	particles_process.scale_max = my_scale_max
	particles_process.scale_min = my_scale_max - scale_diff

func _set_my_velocity_min(_vel: float) -> void:
	my_velocity_min = minf(_vel, my_velocity_max)
	var particles_process : ParticleProcessMaterial = process_material as ParticleProcessMaterial
	particles_process.initial_velocity_min = my_velocity_min


func _set_my_velocity_max(_vel: float) -> void:
	my_velocity_max = maxf(_vel, my_velocity_min)
	var particles_process : ParticleProcessMaterial = process_material as ParticleProcessMaterial
	particles_process.initial_velocity_max = my_velocity_max


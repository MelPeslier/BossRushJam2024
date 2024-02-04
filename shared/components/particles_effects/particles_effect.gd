class_name ParticlesEffect
extends Node2D

@export var angle_nodes: Array[Node2D]
@export var dir_nodes: Array[Node2D]
@export var particles: Array[GPUParticles2D]

var angle : float = 0

func activate(_angle: float, _time: float = 3.0) -> void:
	angle = _angle

	give_angle_to_nodes(angle)
	give_dir_to_nodes(angle)
	#give_angle_to_particles(angle)
	emit_all()
	var timer := Timer.new()
	add_child(timer)
	timer.start(_time)
	await timer.timeout
	queue_free()


func give_angle_to_nodes(_angle: float) -> void:
	for angle_node: Node2D in angle_nodes:
		angle_node.rotation = _angle

func give_dir_to_nodes(_angle: float) -> void:
	var _dir: float = 1
	if _angle > PI/2 and _angle < 3*PI/2:
		_dir = -1
	for dir_node: Node2D in dir_nodes:
		dir_node.scale.x *= _dir

#func give_angle_to_particles(_angle: float) -> void:
	#for particle: GPUParticles2D in particles:
		#var mat : ParticleProcessMaterial = particle.process_material as ParticleProcessMaterial

func emit_all() -> void:
	for particle: GPUParticles2D in particles:
		#var mat : ParticleProcessMaterial = particle.process_material as ParticleProcessMaterial
		particle.emitting = true

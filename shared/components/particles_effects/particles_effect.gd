class_name ParticlesEffect
extends Node2D

@export var nodes: Array[Node2D]
@export var particles: Array[GPUParticles2D]

var angle : float = 0

func activate(_angle: float, _time: float = 10.0) -> void:
	angle = _angle

	give_angle_to_nodes(angle)
	#give_angle_to_particles(angle)
	emit_all()
	var timer := Timer.new()
	add_child(timer)
	timer.start(_time)
	await timer.timeout
	queue_free()


func give_angle_to_nodes(_angle: float) -> void:
	for node: Node2D in nodes:
		node.rotation = _angle

#func give_angle_to_particles(_angle: float) -> void:
	#for particle: GPUParticles2D in particles:
		#var mat : ParticleProcessMaterial = particle.process_material as ParticleProcessMaterial

func emit_all() -> void:
	for particle: GPUParticles2D in particles:
		#var mat : ParticleProcessMaterial = particle.process_material as ParticleProcessMaterial
		particle.emitting = true

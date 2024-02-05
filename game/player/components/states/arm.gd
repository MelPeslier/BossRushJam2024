extends PlayerAbilityState

@export var arm_juice: GPUParticles2D

func exit() -> void:
	super()
	arm_juice.emitting = false


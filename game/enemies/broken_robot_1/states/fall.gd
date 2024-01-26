extends MoveState

@export var idle: State
@export var terrain_detector: TerrainDetector

var fall_timer: float = 0

func enter() -> void:
	super()
	fall_timer = 0


func process_physics(delta: float) -> State:
	fall_timer += delta

	do_air_decelerate(delta)
	do_gravity(delta)
	parent.move_and_slide()

	if parent.is_on_floor():
		match terrain_detector.get_terrain_type():
			Terrain.TerrainType.METAL:
				if fall_timer > move_data.jump_time_to_descent + 0.01:
					Sfx2d.play_metal(SoundList.Metal.LAND_MEDIUM, parent.global_position)
				else:
					Sfx2d.play_metal(SoundList.Metal.LAND_LIGHT, parent.global_position)
		return idle
	return null

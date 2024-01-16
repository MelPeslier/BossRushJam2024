extends AbilityInputComponent


func wants_melee_attack() -> bool:
	return Input.is_action_just_pressed("melee_attack")

func wants_distance_attack() -> bool:
	return Input.is_action_just_pressed("distance_attack")

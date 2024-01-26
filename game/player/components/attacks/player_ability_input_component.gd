extends AbilityInputComponent


func wants_main_attack() -> bool:
	return Input.is_action_just_pressed("melee_attack")

func wants_secondary_attack() -> bool:
	return Input.is_action_just_pressed("distance_attack")

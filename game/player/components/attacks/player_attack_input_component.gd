extends AttackInputComponent

@export var player: Player


func wants_melee_attack() -> bool:
	return Input.is_action_just_pressed("melee_attack")


func wants_distance_attack() -> bool:
	return Input.is_action_just_pressed("distance_attack")


func wants_special_capacity_1() -> bool:
	return Input.is_action_just_pressed("special_capacity_1")


func wants_attack() -> bool:
	return wants_melee_attack() or wants_distance_attack()


func can_attack() -> bool:
	return true

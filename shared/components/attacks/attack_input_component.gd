class_name AbilityInputComponent
extends Node

var _can_attack := true


func wants_melee_attack() -> bool:
	return false

func wants_distance_attack() -> bool:
	return false


func wants_special_ability_1() -> bool:
	return false

func wants_special_ability_2() -> bool:
	return false


func wants_spell_1() -> bool:
	return false

func wants_spell_2() -> bool:
	return false

func wants_spell_3() -> bool:
	return false

func wants_spell_4() -> bool:
	return false


func wants_attack() -> bool:
	return _can_attack


func can_attack() -> bool:
	return _can_attack

func disable_attack() -> void:
	_can_attack = false

func enable_attack() -> void:
	_can_attack = true

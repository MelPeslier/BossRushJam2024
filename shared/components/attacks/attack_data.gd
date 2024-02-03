class_name AttackData
extends Node

enum Team {
	ENEMY,
	PLAYER,
	SPIKE,
}

#enum AttackType {
	#NORMAL
#}

@export var team := Team.ENEMY
@export var damage: float = 0
@export var knock_back: float = 0
@export var can_gain_energy := false
#@export var attack_types: Array[AttackType]

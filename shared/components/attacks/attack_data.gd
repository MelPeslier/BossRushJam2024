class_name AttackData
extends Node

enum Team {
	ENEMY,
	PLAYER
}

#enum AttackType {
	#NORMAL
#}

@export var team: Team
@export var damage: float = 0
@export var knock_back: float = 0
#@export var attack_types: Array[AttackType]

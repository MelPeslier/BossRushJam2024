class_name AttackSpecialEffects
extends Node

@export_category("Movements")
@export var frame_move: int = -1

@export_category("Dash")
@export var dash_velocity: float
@export var dash_time: float

@export_category("Burst")
@export var burst_velocity: float


# Dash
var dash_timer: float


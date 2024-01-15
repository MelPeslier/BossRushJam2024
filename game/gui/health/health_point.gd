class_name HealthPoint
extends PanelContainer

@export var fill: TextureRect


func lose_health() -> void:
	fill.visible = false


func gain_health() -> void:
	fill.visible = true

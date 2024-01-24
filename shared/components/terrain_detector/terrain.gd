class_name Terrain
extends StaticBody2D

enum TerrainType {
	NONE,
	METAL,
}

const custom_data_layers: Array[StringName] = [
	&"TerrainType",
	&"Border",
]

@export var terrain_type: TerrainType

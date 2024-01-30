class_name Terrain
extends StaticBody2D

enum TerrainType {
	NONE,
	METAL,
}

enum CustomDataLayers {
	TERRAIN_TYPE,
	BORDER,
	GROUND,
}

static var custom_data_layers: Array[StringName] = [
	&"TerrainType",
	&"Border",
	&"Ground",
]

@export var terrain_type: TerrainType

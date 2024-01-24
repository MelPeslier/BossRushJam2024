class_name TerrainDetector
extends Area2D

signal terrain_entered(terrain_type: Terrain.TerrainType)

var current_tilemap: TileMap = null
var current_tile_data: TileData = null
var current_terrain: Terrain = null

func _ready() -> void:
	body_shape_entered.connect( _on_body_shape_entered )
	body_shape_exited.connect ( _on_body_shape_exited )

func _exit_tree() -> void:
	current_tilemap = null
	current_terrain = null


func _process_tilemap_collision(tile_map: TileMap, body_rid: RID) -> void:
	current_tilemap = tile_map
	var layer := current_tilemap.get_layer_for_body_rid(body_rid)
	var tile_coords: Vector2 = current_tilemap.get_coords_for_body_rid( body_rid )
	var tile_data: TileData = current_tilemap.get_cell_tile_data(layer, tile_coords)
	current_tile_data = tile_data


func _process_terrain_collision(terrain: Terrain) -> void:
	current_terrain = terrain


func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMap:
		_process_tilemap_collision(body, body_rid)
		return

	if body is Terrain:
		_process_terrain_collision(body)
		return

	print("unknown type entered: ", body.name)


func _on_body_shape_exited(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMap:
		if current_tilemap == body:
			current_tilemap = null
			current_tile_data = null
		return

	if body is Terrain:
		if current_terrain == body:
			current_terrain = null
		return

	print("unknown type exited: ", body.name)

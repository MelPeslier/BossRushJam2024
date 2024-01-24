class_name MyTileMap
extends TileMap

static var tile_map: TileMap = null

static var type_layer = 1
static var type_name = "Type"
static var type_metal = 1

static var border_layer = 1
static var border_name = "Border"
static var border_left = -1
static var border_right = 1


func _ready() -> void:
	tile_map = self

extends PlayerState

@export var idle: State
@export var jump: State
@export var fall: State
@export var dash: State


func process_physics(delta: float) -> State:
	super(delta)
	move_data.dir = get_movement_input()
	if not move_data.dir or not move_data.can_move:
		return idle
	do_walk_accelerate(delta)
	parent.apply_floor_snap()
	parent.move_and_slide()

	for i: int in parent.get_slide_collision_count():
		var collision: KinematicCollision2D = parent.get_slide_collision(i)
		if not collision: continue

		var collider_rid : RID = collision.get_collider_rid()
		var tile_coords : Vector2 = MyTileMap.tile_map.get_coords_for_body_rid( collider_rid )
		print(tile_coords)
		var tile_data : TileData = MyTileMap.tile_map.get_cell_tile_data(0, tile_coords)
		print(tile_data)
		if not tile_data: continue
		print("tile_data : ", tile_data)
		var a = tile_data.get_custom_data(MyTileMap.border_name)
		if a:
			print("border: ", a)

			print("Collided with: ", collision.get_collider().name, "  tile_data : ", tile_data)


	if not parent.is_on_floor():
		return fall
	return null


func process_unhandled_input(_event: InputEvent) -> State:
	if get_dash() and move_data.can_dash():
		return dash
	if get_jump() and move_data.can_jump():
		return jump
	return null

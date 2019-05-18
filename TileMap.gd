extends TileMap


func isTileFree(selected_tile : Vector2, characters_positions : Array):
	var res : bool = selected_tile in get_used_cells()
	for position in characters_positions:
		if selected_tile == world_to_map(position):
			return false
	return res
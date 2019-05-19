extends TileMap

# Reference to a new AStar navigation grid node
onready var astar = AStar.new()
# Used to find the centre of a tile
onready var half_cell_size = cell_size / 2
# All tiles that can be used for pathfinding
onready var traversable_tiles = get_used_cells()
# The bounds of the rectangle containing all used tiles on this tilemap
onready var used_rect = get_used_rect()

var backtracks : Dictionary

func _ready():
	# This would hide the navigation_map upon loading, but we'll keep
	# it commented for this demo - uncomment for your game, most likely
	# visible = false

	# Add all tiles to the navigation grid
	_add_traversable_tiles(traversable_tiles)
	# Connects all added tiles
	_connect_traversable_tiles(traversable_tiles)
	
## Private functions

# Adds tiles to the A* grid but does not connect them
# ie. They will exist on the grid, but you cannot find a path yet
func _add_traversable_tiles(traversable_tiles):
	# Loop over all tiles
	for tile in traversable_tiles:
		# Determine the ID of the tile
		var id = _get_id_for_point(tile)
		# Add the tile to the AStar navigation
		# NOTE: We use Vector3 as AStar is, internally, 3D. We just don't use Z.
		astar.add_point(id, Vector3(tile.x, tile.y, 0))

# Connects all tiles on the A* grid with their surrounding tiles
func _connect_traversable_tiles(traversable_tiles):
	# Loop over all tiles
	for tile in traversable_tiles:
		# Determine the ID of the tile
		var id = _get_id_for_point(tile)
		# Loops used to search around player (range(3) returns 0, 1, and 2)
		for x in range(3):
			for y in range(3):
				# Determines target, converting range variable to -1, 0, and 1
				var target = tile + Vector2(x - 1, y - 1)
				# Determines target ID
				var target_id = _get_id_for_point(target)
				# Do not connect if point is same or point does not exist on astar
				if tile == target or not astar.has_point(target_id):
					continue
				# Do not connect diagonals
				if x-1 != 0 and y-1 != 0:
					continue
				# Connect points
				astar.connect_points(id, target_id, true)


# Determines a unique ID for a given point on the map
func _get_id_for_point(point):
	# Offset position of tile with the bounds of the tilemap
	# This prevents ID's of less than 0, if points are behind (0, 0)
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	# Returns the unique ID for the point on the map
	return x + y * used_rect.size.x


## Public functions

# Returns a path from start to end
# These are real positions, not cell coordinates
func get_astar_path(start, end):
	# Convert positions to cell coordinates
	var start_tile = world_to_map(start)
	var end_tile = world_to_map(end)
	# Determines IDs
	var start_id = _get_id_for_point(start_tile)
	var end_id = _get_id_for_point(end_tile)
	# Return null if navigation is impossible
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return null
	# Otherwise, find the map
	var path_map = astar.get_point_path(start_id, end_id)
	# Convert Vector3 array (remember, AStar is 3D) to real world points
	var path_world = []
	for point in path_map:
		var point_world = map_to_world(Vector2(point.x, point.y)) + Vector2(0,cell_size.y/2)
		path_world.append(point_world)
	# If the path is empty then the goal is unreachable
	if path_world == []:
		
		return null
		
	return path_world

func isTileFree(selected_tile : Vector2, characters_positions : Array):
	var res : bool = selected_tile in get_used_cells()
	for position in characters_positions:
		if selected_tile == world_to_map(position):
			return false
	return res

func tile_peripheriques():
	var topLeft : Vector2 = Vector2(-1,0)
	var topRight : Vector2 = Vector2(0,-1)
	var bottomLeft : Vector2 = Vector2(0,1)
	var bottomRight : Vector2 = Vector2(1,0)
	
	var result : Array = Array()
	for tile in get_used_cells():
		if not (tile + topLeft in get_used_cells()):
			result.append(tile)
			continue
		if not (tile + topRight in get_used_cells()):
			result.append(tile)
			continue
		if not (tile + bottomLeft in get_used_cells()):
			result.append(tile)
			continue
		if not (tile + bottomRight in get_used_cells()):
			result.append(tile)
			continue
	return result
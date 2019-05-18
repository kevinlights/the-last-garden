extends Sprite

onready var tileMap : TileMap = get_node("../../TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile : Vector2 = tileMap.world_to_map(get_global_mouse_position())
	print(tile)
	if tile in tileMap.get_used_cells():
		visible = true
		global_position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
	else : 
		visible = false

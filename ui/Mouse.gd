extends Sprite

onready var tileMap : TileMap = get_node("../../TileMap")
onready var turnQueue : Node = get_node("../../TurnQueue")
onready var visualisationPlantSkill : TileMap = get_node("../VisualisationPlantSkill")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile : Vector2 = tileMap.world_to_map(get_global_mouse_position())
	#print(tile)
	if tile in tileMap.get_used_cells():
		visible = true
		global_position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
		
		var hovered_character = turnQueue.get_plant_from_pos(global_position)
		if hovered_character != null:
			visualisationPlantSkill.set_visualisation(hovered_character)
		else :
			visualisationPlantSkill.hide()
		
	else : 
		visible = false

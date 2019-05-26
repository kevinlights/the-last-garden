extends TileMap

onready var tileMap : TileMap = get_node("../../TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func set_visualisation(character : Character):
	clear()
	visible = true
	var tiles : Array = character.get_skill_zone()
	
	for tile in tiles:
		if tile in tileMap.get_used_cells():
			if character.type == "Pissenlit":
				tile_set.tile_set_modulate (0, Color(1,0.39,0.39,1)) # Rouge
				set_cellv (tile,0)
			elif character.type == "Rafflesia":
				tile_set.tile_set_modulate (0, Color(0.9,0.39,1,1)) # Rose
				set_cellv (tile,0)
			elif character.type == "Ronce":
				tile_set.tile_set_modulate (0, Color(1,0.39,0.39,1)) # Rouge
				set_cellv (tile,0)
			elif character.type == "PlanteBleu":
				tile_set.tile_set_modulate (0, Color(0.15,0.66,0.2,1)) # Vert
				set_cellv (tile,0)
			elif character.type == "Insect":
				tile_set.tile_set_modulate (0, Color(0.39,0.5,1,1)) # Bleu
				set_cellv (tile,0)
			
func hide():
	tile_set.tile_set_modulate(0, Color(1,1,1,1))
	visible = false
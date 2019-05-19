extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func set_visualisation(character : Character):
	clear()
	visible = true
	var tiles : Array = character.get_skill_zone()
	
	for tile in tiles:
		if character.type == "Pissenlit":
			set_cellv (tile,0)
		elif character.type == "Rafflesia":
			set_cellv (tile,0)
		elif character.type == "Ronce":
			set_cellv (tile,0)
		elif character.type == "PlanteBleu":
			set_cellv (tile,0)
		elif character.type == "Insect":
			set_cellv (tile,0)
			
func hide():
	visible = false
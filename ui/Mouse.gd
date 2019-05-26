extends Sprite

onready var tileMap : TileMap = get_node("../../TileMap")
onready var turnQueue : Node = get_node("../../TurnQueue")
onready var visualisationPlantSkill : TileMap = get_node("../VisualisationPlantSkill")

onready var pissenlit_ressource = load("res://Characters/Plants/Pissenlit.tscn")
onready var rafflesia_ressource = load("res://Characters/Plants/Rafflesia.tscn")
onready var ronces_ressource = load("res://Characters/Plants/Ronces.tscn")
onready var fleurbleue_ressource = load("res://Characters/Plants/FleurBleu.tscn")

var selected_plant : Character = null

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
			if selected_plant != null:
				selected_plant.visible = false
			visualisationPlantSkill.set_visualisation(hovered_character)
		else :
			if selected_plant != null:
				selected_plant.global_position = global_position
				if not (tileMap.world_to_map(selected_plant.global_position) in tileMap.getCorruptedTiles()):
					selected_plant.visible = true
					visualisationPlantSkill.set_visualisation(selected_plant)
				else:
					selected_plant.visible = false
					visualisationPlantSkill.hide()
			else:
				visualisationPlantSkill.hide()
	else :
		visualisationPlantSkill.hide()
		if selected_plant != null:
			selected_plant.visible = false
		visible = false


func _on_ui_hud_plant_selected(plant):
	get_parent().remove_child(selected_plant)
	match plant:
		"pissenlit":
			selected_plant = pissenlit_ressource.instance()
			selected_plant.position = global_position
			get_parent().add_child(selected_plant)
			selected_plant.sprite.modulate = Color(1, 1, 1, 0.5)
		"rafflesia":
			selected_plant = rafflesia_ressource.instance()
			selected_plant.position = global_position
			get_parent().add_child(selected_plant)
			selected_plant.sprite.modulate = Color(1, 1, 1, 0.5)
		"ronces":
			selected_plant = ronces_ressource.instance()
			selected_plant.position = global_position
			get_parent().add_child(selected_plant)
			selected_plant.sprite.modulate = Color(1, 1, 1, 0.5)
		"fleurbleue":
			selected_plant = fleurbleue_ressource.instance()
			selected_plant.position = global_position
			get_parent().add_child(selected_plant)
			selected_plant.sprite.modulate = Color(1, 1, 1, 0.5)


func _on_EndTurnButton_pressed():
	get_parent().remove_child(selected_plant)
	visible = false
	selected_plant = null

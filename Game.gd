extends Node2D

onready var tileMap : TileMap = $TileMap
onready var terrain = get_node("TileMap/terrain")
onready var turnQueue : Node = $TurnQueue
onready var ui_hud : CanvasLayer = $ui_hud
onready var ui_navigation : Node = $ui_navigation

onready var plantemere_ressource = load("res://Characters/Plants/PlanteMere.tscn")
onready var pissenlit_ressource = load("res://Characters/Plants/Pissenlit.tscn")
onready var rafflesia_ressource = load("res://Characters/Plants/Rafflesia.tscn")
onready var insectotueur_ressource = load("res://Characters/Insects/insectotueur.tscn")

export var mana_max : int = 2
export var pissenlits_max : int = 2
export var raflesia_max : int = 2
export var cout_mana_pissenlit : int = 1
export var cout_mana_raflesia : int = 1

var mana : int
var nombre_plantes : Dictionary = {}
var couts_plantes : Dictionary = {}

enum ETAT {
	SELECT_PLANT,
	SELECT_TILE,
	END_TURN
}

onready var queen_position : Vector2 = tileMap.map_to_world(Vector2(4,-1))

var etat_courant = ETAT.SELECT_PLANT
var selected_plant = null
var selected_tile : Vector2 = Vector2(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	mana = mana_max
	nombre_plantes["pissenlit"] = pissenlits_max
	nombre_plantes["rafflesia"] = raflesia_max
	couts_plantes["pissenlit"] = cout_mana_pissenlit
	couts_plantes["rafflesia"] = cout_mana_raflesia
	ajouter_reine()
	insect_spawner(15)
	play()
	
func play():
	while true:
		match etat_courant:
			ETAT.SELECT_PLANT:
				# Selection d'une graine
				# TODO : deselection
				ui_hud.select_plant()
				yield(ui_hud,"plant_selected")
				etat_courant = ETAT.SELECT_TILE if etat_courant != ETAT.END_TURN else etat_courant
				#print("selected plant:",selected_plant)
			ETAT.SELECT_TILE:
				# Selection d'une case pour poser la graine
				# TODO : mauvaise selection et deselection
				ui_navigation.select_tile()
				selected_tile = yield(ui_navigation,"tile_selected")
				if etat_courant != ETAT.END_TURN:
					if nombre_plantes[selected_plant]-1 >= 0 and mana-couts_plantes[selected_plant] >= 0 :
						if tileMap.isTileFree(selected_tile,turnQueue.get_characers_positions()) : #and not terrain.getBloc(selected_tile).isCorrupted:
							ajouter_character(selected_plant, selected_tile)
							mana -= couts_plantes[selected_plant]
							nombre_plantes[selected_plant] -= 1
							etat_courant = ETAT.SELECT_TILE
							print("selected tile :",selected_tile)
					else :
						etat_courant = ETAT.SELECT_TILE

			ETAT.END_TURN:
				turnQueue.play_turn()
				yield(turnQueue,"turn_finished")
				mana = mana_max
				nombre_plantes["pissenlit"] = pissenlits_max
				nombre_plantes["rafflesia"] = raflesia_max
				etat_courant = ETAT.SELECT_PLANT
				print("End turn")

func insect_spawner(max_nb_insect : int):
	
	var nb_insects : int = randi() % max_nb_insect + 1
	
	var enemy_spawn_postions : Array = tileMap.tile_peripheriques()
	for i in range(nb_insects):
		var test_spawn = randi() % enemy_spawn_postions.size()
		ajouter_instect("insectotueur", enemy_spawn_postions[test_spawn],queen_position)
		enemy_spawn_postions.remove(test_spawn)

func _on_EndTurnButton_pressed():
	etat_courant = ETAT.END_TURN

func _on_ui_hud_plant_selected(plant):
	if etat_courant in [ETAT.SELECT_TILE,ETAT.SELECT_PLANT]:
		selected_plant = plant
		print("selected plant:",selected_plant)
		
func ajouter_character(character_name : String, tile : Vector2):
	var new_character
	match character_name:
		"pissenlit":
			new_character = pissenlit_ressource.instance()
			new_character.position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
		"rafflesia":
			new_character = rafflesia_ressource.instance()
			new_character.position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
	turnQueue.add_character(new_character)
	
func ajouter_instect(instect_name : String, tile : Vector2, cible : Vector2):
	var new_instect
	match instect_name:
		"insectotueur":
			new_instect = insectotueur_ressource.instance()
			new_instect.position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
			new_instect.set_target(cible)
	turnQueue.add_character(new_instect)
	
func ajouter_reine():
	var new_queen = plantemere_ressource.instance()
	new_queen.position = queen_position
	turnQueue.add_character(new_queen)

func _on_game_won():
	$ui_hud/EcranFinDePartie.show()
	$ui_hud/EcranFinDePartie/VBoxContainer/CenterContainer/VICTOIRE.show()

func _on_game_lost():
	$ui_hud/EcranFinDePartie.show()
	$ui_hud/EcranFinDePartie/VBoxContainer/CenterContainer/DEFAITE.show()

func _on_Rejouer_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_Retour_pressed():
	get_tree().change_scene("res://Menu.tscn")
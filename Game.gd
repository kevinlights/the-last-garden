"""
Licensed under GPL-3.0-or-later
Copyright (C) 2019 Louka Soret

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

extends Node2D

signal mana_set(mana)
signal plants_changed(slots)
signal plant_posee(slot)

onready var tileMap : TileMap = $TileMap
onready var terrain = get_node("TileMap/terrain")
onready var turnQueue : Node = $TurnQueue
onready var ui_hud : CanvasLayer = $ui_hud
onready var ui_navigation : Node = $ui_navigation

onready var plantemere_ressource = load("res://Characters/Plants/PlanteMere.tscn")
onready var pissenlit_ressource = load("res://Characters/Plants/Pissenlit.tscn")
onready var rafflesia_ressource = load("res://Characters/Plants/Rafflesia.tscn")
onready var ronces_ressource = load("res://Characters/Plants/Ronces.tscn")
onready var fleurbleue_ressource = load("res://Characters/Plants/FleurBleu.tscn")
onready var insectotueur_ressource = load("res://Characters/Insects/insectotueur.tscn")

# Nombre de plantes
export var nb_plants_per_turn : int = 3
export var pissenlit_chance : float = 0.35 #commun
export var raflesia_chance : float = 0.55 #rare
export var ronces_chance : float = 0.90 # commun
export var fleurbleue_chance : float = 1 # epic

# Couts des plantes
export var mana_max : int = 2
export var cout_mana_pissenlit : int = 1
export var cout_mana_raflesia : int = 1
export var cout_mana_ronces : int = 1
export var cout_mana_fleurbleue : int = 1

# Parametre spawn insects
export var spawn_insect_min : int = 3
export var spawn_insect_max : int = 4
export var spawn_insect_wave_step : int = 2
export var spawn_insect_min_turn_step : int = 1
export var spawn_insect_max_turn_step : int = 1
export var next_wave_turn_step : int = 2
export var next_wave_hatch_step : int = 1

var mana : int
var slots : Array = Array()
var couts_plantes : Dictionary = {}

enum ETAT {
	SELECT_PLANT,
	SELECT_TILE,
	END_TURN
}

onready var queen_position : Vector2 = tileMap.map_to_world(Vector2(4,-1))

var etat_courant = ETAT.SELECT_PLANT
var selected_plant = null
var selected_tile : Vector2 = Vector2(-100,-100)
var current_wave : int
var next_wave_turn : int = next_wave_turn_step
var next_wave_hatch : int = 1
var game_won : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	current_wave = 0
	mana = mana_max

	emit_signal("mana_set", mana)
	
	add_plants()
	couts_plantes["pissenlit"] = cout_mana_pissenlit
	couts_plantes["rafflesia"] = cout_mana_raflesia
	couts_plantes["ronces"] = cout_mana_ronces
	couts_plantes["fleurbleue"] = cout_mana_fleurbleue
	ajouter_reine()
	
	insect_spawner(spawn_insect_min,spawn_insect_max)

	if global.display_tutorial:
		$ui_hud.showInitialMessage()
		
	global.display_tutorial = false
	
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
					if mana-couts_plantes[selected_plant] >= 0 :
						if tileMap.isTileFree(selected_tile,turnQueue.get_characers_positions()) and not terrain.getBloc(selected_tile).isCorrupted:
							ajouter_character(selected_plant, selected_tile)
							mana -= couts_plantes[selected_plant]
							emit_signal("mana_set", mana)
							etat_courant = ETAT.SELECT_PLANT
							print("selected tile :",selected_tile)
					else :
						etat_courant = ETAT.SELECT_TILE

			ETAT.END_TURN:
				turnQueue.play_turn()
				yield(turnQueue,"turn_finished")
				yield(get_tree().create_timer(1), "timeout")
				if(not game_won):
					if (not turnQueue.as_insect_unhatched()):
						var tmp_wave_hatch : int = next_wave_hatch
						current_wave += 1
						next_wave_hatch = 1
						if (current_wave % spawn_insect_wave_step) == 0 :
							print("satut")
							spawn_insect_min += spawn_insect_min_turn_step
							spawn_insect_max += spawn_insect_max_turn_step
						insect_spawner(spawn_insect_min,spawn_insect_max)
						next_wave_hatch = tmp_wave_hatch
						next_wave_turn = turnQueue.turn_number + next_wave_turn_step + next_wave_hatch
					elif turnQueue.turn_number >= next_wave_turn:
						current_wave += 1
						next_wave_turn = turnQueue.turn_number + next_wave_turn_step + next_wave_hatch
						if (current_wave % spawn_insect_wave_step) == 0 :
							print("satut")
							spawn_insect_min += spawn_insect_min_turn_step
							spawn_insect_max += spawn_insect_max_turn_step
						insect_spawner(spawn_insect_min,spawn_insect_max)
				mana = mana_max
				emit_signal("mana_set", mana)
				add_plants()
				etat_courant = ETAT.SELECT_PLANT
				print("End turn")

func add_plants():
	var choose : float
	slots = []
	for i in range(nb_plants_per_turn):
		randomize()
		choose = randf()
		if choose <= pissenlit_chance:
			slots.append("pissenlit") 
		elif choose <= raflesia_chance:
			slots.append("rafflesia")
		elif choose <= ronces_chance:
			slots.append("ronces")
		elif choose <= fleurbleue_chance:
			slots.append("fleurbleue")
	emit_signal("plants_changed",slots)

func insect_spawner(spawn_min : int, spawn_max : int):
	
	randomize()
	var nb_insects : int = (randi() % ((spawn_max-spawn_min)+1)) + spawn_min
	print(nb_insects)
	
	var enemy_spawn_postions : Array = tileMap.tile_peripheriques()
	turnQueue.delete_occupied_tiles(enemy_spawn_postions)
	for i in range(nb_insects):
		randomize()
		var test_spawn = randi() % enemy_spawn_postions.size()
		ajouter_instect("insectotueur", enemy_spawn_postions[test_spawn],queen_position)
		enemy_spawn_postions.remove(test_spawn)
	next_wave_hatch += next_wave_hatch_step

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
		"ronces":
			new_character = ronces_ressource.instance()
			new_character.position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
		"fleurbleue":
			new_character = fleurbleue_ressource.instance()
			new_character.position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
	turnQueue.add_character(new_character)
	emit_signal("plant_posee",slots.find(character_name))
	slots.remove(slots.find(character_name))
	
func ajouter_instect(instect_name : String, tile : Vector2, cible : Vector2):
	var new_instect
	match instect_name:
		"insectotueur":
			new_instect = insectotueur_ressource.instance()
			new_instect.position = tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2)
			new_instect.turns_to_hatch = next_wave_hatch
			new_instect.set_target(cible)
	turnQueue.add_character(new_instect)
	
func ajouter_reine():
	var new_queen = plantemere_ressource.instance()
	new_queen.position = queen_position
	turnQueue.add_character(new_queen)

func _on_game_won():
	game_won = true
	$ui_hud.showVictoryScreen()

func _on_game_lost():
	$Sounds/Musique.stop()
	$Sounds/MusiqueDefaite.play()
	$ui_hud.showDefeatScreen()
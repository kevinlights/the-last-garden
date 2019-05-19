extends Node

signal turn_finished()

onready var tileMap : TileMap = get_node("../TileMap")

var turn_number : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Met a jour tous les characters
func play_turn():
	for child in get_characters():
		child.update()
		yield(child,"updated")
	turn_number += 1
	emit_signal("turn_finished")

func caracter_priority_sort(a : Character, b : Character) -> bool:
	return a.is_insect

#Ajoute un character au jeu
func add_character(character):
	add_child(character)

#Renvois les characters dans le jeu
func get_characters():
	var characters = get_children()
	characters.sort_custom(self,"caracter_priority_sort")
	return characters
	
func get_characers_positions():
	var positions : Array = Array()
	for character in get_characters():
		if not character.to_remove:
			positions.append(character.global_position)
	return positions

func contain_enemy(tile : Vector2):
	for character in get_characters():
		if character.is_insect :
			if tileMap.world_to_map(character.global_position) == tile:
				return true
	return false

# Si un insecte marche sur une plante il la detruis
func _on_insect_on(position):
	for character in get_characters():
		if not character.is_insect :
			if tileMap.world_to_map(character.global_position) == position:
				character.fade()

# Si un proectile touche un insect il le detruis
func _on_projectile_done(position):
	for character in get_characters():
		if character.is_insect :
			if tileMap.world_to_map(character.global_position) == tileMap.world_to_map(position):
				character.fade()
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

extends Node

signal turn_finished()

onready var tileMap : TileMap = get_node("../TileMap")
onready var root : Node2D = get_parent()

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
	return a.is_insect or a.is_insect_unhatched

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

func get_characers_tiles():
	var positions : Array = Array()
	for character in get_characters():
		if not character.to_remove:
			positions.append(tileMap.world_to_map(character.global_position))
	return positions

func contain_enemy(tile : Vector2):
	for character in get_characters():
		if character.is_insect :
			if tileMap.world_to_map(character.global_position) == tile:
				if not character.to_remove:
					return true
	return false
	
func contain_enemy_unhatched(tile : Vector2):
	for character in get_characters():
		if character.is_insect or character.is_insect_unhatched:
			if tileMap.world_to_map(character.global_position) == tile :
				if not character.to_remove:
					return true
	return false

func attract_to_in_set( attract_radius : int, cible : Vector2):
	for character in get_characters():
		if character.is_insect :
			if tileMap.world_to_map(character.global_position).distance_to(tileMap.world_to_map(cible)) <= attract_radius:
				if not character.to_remove:
					character.set_target(cible) #WORLD

func find_closest_raflesia(tile : Vector2):
	var best : Vector2 = Vector2(90000,90000)
	for character in get_characters():
		if character.is_raflesia :
			if tileMap.world_to_map(character.global_position).distance_to(tileMap.world_to_map(tile)) <= character.attract_radius:
				if tileMap.world_to_map(character.global_position).distance_to(tileMap.world_to_map(tile)) < tileMap.world_to_map(best).distance_to(tileMap.world_to_map(tile)):
					best =  character.global_position
	if best == Vector2(90000,90000):
		best = root.queen_position
	return best

func get_plant_from_pos(position : Vector2):
	for character in get_characters():
		if not character.to_remove:
			if tileMap.world_to_map(character.global_position) == tileMap.world_to_map(position):
				return character
	return null

func as_insect():
	for character in get_characters():
		if character.is_insect and not character.to_remove:
			return true
	return false

func as_insect_unhatched():
	for character in get_characters():
		if (character.is_insect or character.is_insect_unhatched) and not character.to_remove:
			return true
	return false

func contain_ronce(position : Vector2):
	for character in get_characters():
		if not character.is_insect and character.is_ronce and not character.to_remove:
			if tileMap.world_to_map(character.global_position) == tileMap.world_to_map(position):
				return true
	return false

# Si un insecte marche sur une plante il la detruis
func _on_insect_on(position):
	for character in get_characters():
		if not character.is_insect and not character.to_remove :
			if tileMap.world_to_map(character.global_position) == position:
				character.fade()

# Si un proectile touche un insect il le detruis
func _on_projectile_done(position):
	for character in get_characters():
		if character.is_insect :
			if tileMap.world_to_map(character.global_position) == tileMap.world_to_map(position):
				character.fade()
				
func kill_all_insect():
	for character in get_characters():
		if character.is_insect or character.is_insect_unhatched:
				character.fade()
				
func delete_occupied_tiles(enemy_spawn_postions : Array):
	for occupied in get_characers_tiles():
		if occupied in enemy_spawn_postions:
			enemy_spawn_postions.remove(enemy_spawn_postions.find(occupied))
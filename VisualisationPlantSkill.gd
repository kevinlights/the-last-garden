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
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

signal tile_selected(tile)

onready var tileMap : TileMap = get_node("../TileMap")
onready var mouse : Sprite = $Mouse

var selecting_tile : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Suspend le jeu jusqu'a qu'une tile soit selectionnee
func select_tile():
	selecting_tile = true
	var tile : Vector2 = yield(self,"tile_selected")
	selecting_tile = false

# Gestion des inputs de navigation sur la tilemap
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if selecting_tile:
				var tile : Vector2 = tileMap.world_to_map(mouse.global_position) if mouse.visible else Vector2(-100,-100)
				emit_signal("tile_selected",tile)
				get_tree().set_input_as_handled()

func _on_EndTurnButton_pressed():
	emit_signal("tile_selected",Vector2(-1,-1))
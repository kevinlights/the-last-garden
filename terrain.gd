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

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bloc_ressource = load("res://bloc/Bloc.tscn")
var d : Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	var tm : TileMap= get_parent()
	var blocs : Array

	for v in tm.get_used_cells():
		var go = bloc_ressource.instance()
		go.position = tm.map_to_world(v) + Vector2(0,tm.cell_size.y)
		self.add_child(go)
		d[v] = go
		
func getBloc(v):
	return d[v]

func getCorruptedTiles():
	var res : Array = Array()
	for v in get_parent().get_used_cells():
		if d[v].isCorrupted:
			res.append(v)
	return res

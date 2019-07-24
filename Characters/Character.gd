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

class_name Character

signal updated()

var type : String = "Character"
var is_insect : bool
var is_raflesia : bool = false
var is_ronce : bool = false
var to_remove : bool = false
var is_insect_unhatched : bool = false
var is_mere : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_insect = false

# Play the next turn for the character
func update():
	emit_signal("updated")
	
func get_skill_zone():
	return []
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
var isCorrupted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$grass.material = $grass.material.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func uncorrupt():
	if(isCorrupted):
		isCorrupted = false
		$AnimationPlayer.play("uncorrupt")
		

func corrupt():
	if(!isCorrupted):
		isCorrupted = true
		$AnimationPlayer.play("corrupt")
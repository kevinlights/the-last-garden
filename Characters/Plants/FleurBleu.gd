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

extends Character

signal hatch_done_internal()

onready var sprite : Sprite = $FleurBleuSprite
onready var tileMap : TileMap = get_node("../../TileMap")
onready var terrain  = get_node("../../TileMap/terrain")
onready var longevite = get_node("FleurBleuSprite/Longevite")

export var turns_to_hatch : int = 2
export var turns_to_fade : int = 8

var sprites : Dictionary = {"seed":0,"adult":1}
var skill_directions : Array = [Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1)]
var current_turn : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	type = "PlanteBleu"
	$FleurBleuSprite.frame = sprites["seed"]
	is_insect = false
	$FleurBleuSprite.material = $FleurBleuSprite.material.duplicate();
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(turns_to_hatch - current_turn))

# Play the next turn for the character
func update():
	yield(get_tree().create_timer(0.2), "timeout")
	if not to_remove:
		current_turn += 1
		if current_turn == turns_to_hatch:
			hatch()
			yield(self, "hatch_done_internal")
		if current_turn == turns_to_fade:
			fade()
		
		#Update le label de longévité
		if current_turn < turns_to_hatch:
			longevite.set_text(str(turns_to_hatch - current_turn))
		else:
			var turnsBeforeFade : int = turns_to_fade - current_turn
			if turnsBeforeFade != 0:
				longevite.set_text(str(turnsBeforeFade))
		emit_signal("updated")
	else :
		emit_signal("updated")
		#get_parent().remove_child(self)
		self.queue_free()
		
func hatch():
	yield(get_tree().create_timer(0.2), "timeout")
	$AnimationPlayer.play("meta")
	yield($AnimationPlayer, "animation_finished")
	$FleurBleuSprite.frame = sprites["adult"]
	
	longevite.set("custom_colors/font_color", Color(0.8,0,0))
	
	var current_tile : Vector2 
	var i : int = 1
	for direction in skill_directions:
		current_tile = tileMap.world_to_map(global_position) + direction
		i = 1
		while current_tile in tileMap.get_used_cells():
			terrain.getBloc(current_tile).uncorrupt()
			current_tile = tileMap.world_to_map(global_position) + direction*i
			i += 1
	
	emit_signal("hatch_done_internal")

func fade():
	longevite.set_text("")
	$AnimationPlayer.play("meurt")
	yield($AnimationPlayer, "animation_finished")
	to_remove = true
	
func get_skill_zone():
	var result : Array = Array()
	var current_tile : Vector2 
	var i : int = 1
	for direction in skill_directions:
		current_tile = tileMap.world_to_map(global_position) + direction
		i = 1
		while current_tile in tileMap.get_used_cells():
			result.append(current_tile)
			current_tile = tileMap.world_to_map(global_position) + direction*i
			i += 1
	return result
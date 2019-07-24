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

onready var sprite : Sprite = $RonceSprite
onready var tileMap : TileMap = get_node("../../TileMap")
onready var longevite = get_node("RonceSprite/Longevite")

export var turns_to_hatch : int = 2
export var turns_to_fade : int = 5

var sprites : Dictionary = {"seed":0,"adult":1}
var current_turn : int = 0

func _ready():
	$RonceSprite.frame = sprites["seed"]
	type = "Ronce"
	is_insect = false
	$RonceSprite.material = $RonceSprite.material.duplicate();
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(turns_to_hatch - current_turn))

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
		is_ronce = false
		#get_parent().remove_child(self)
		self.queue_free()

func hatch():
	$AnimationPlayer.play("meta")
	yield(get_tree().create_timer(0.2), "timeout")
	#$RonceSprite.frame = sprites["adult"]
	is_ronce = true
	
	longevite.set("custom_colors/font_color", Color(0.8,0,0))
	emit_signal("hatch_done_internal")

func fade():
	longevite.set_text("")
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimationPlayer.play("meurt")
	yield($AnimationPlayer, "animation_finished")
	to_remove = true

func get_skill_zone():
	return [tileMap.world_to_map(global_position)]

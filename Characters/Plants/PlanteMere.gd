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

signal game_won()
signal game_lost()

onready var soundsMusique : Node = get_node("../../Sounds/Musique")
onready var soundsMusiqueVictoire : Node = get_node("../../Sounds/MusiqueVictoire")

export var beginningLevel : int = 20

onready var longevite = $PlanteMereSprite/Longevite
var currentLevel : int = beginningLevel
onready var tm = get_tree().get_root().get_node("Game/TileMap")
onready var terrain = get_tree().get_root().get_node("Game/TileMap/terrain")
onready var tq = get_tree().get_root().get_node("Game/TurnQueue")

func _ready():
	is_insect = false
	is_mere = true
	connect('game_won', get_parent().get_parent(), '_on_game_won')
	connect('game_lost', get_parent().get_parent(), '_on_game_lost')
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(currentLevel))
	$AnimationPlayer.play("idle")
	
func update():
	if not to_remove:
		yield(get_tree().create_timer(0.2), "timeout")
		currentLevel -= 1
		longevite.set_text(str(currentLevel))
		if(currentLevel == 0):
			hatch()
			yield(self,"game_won")
		emit_signal("updated")
	else :
		emit_signal("updated")
		#get_parent().remove_child(self)
		self.queue_free()
	
func hatch():
	soundsMusique.stop()
	soundsMusiqueVictoire.play()
	$AnimationPlayer.playback_speed = 0.5
	$AnimationPlayer.play("eclosion")
	longevite.set_text("")
	tq.kill_all_insect()
	yield(get_tree().create_timer(0.2), "timeout")
	for v in tm.get_used_cells():
		terrain.getBloc(v).uncorrupt()
	yield($AnimationPlayer, "animation_finished")
	emit_signal("game_won")
	
func fade():
	$AnimationPlayer.play("meurt")
	emit_signal("game_lost")
	yield($AnimationPlayer, "animation_finished")
	to_remove = true

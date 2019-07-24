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

extends Sprite

signal projectile_done(position)

onready var root : Node2D = get_parent().get_parent()
onready var turnQueue : Node = get_node("../TurnQueue")
onready var cam : Camera2D = get_node("../Camera2D")
#onready var boom = load("res://boom.tscn")
onready var boom = load("res://boom_gles2.tscn")


export var speed : int = 500

var goal : Vector2
var launched : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("projectile_done", turnQueue, "_on_projectile_done")

func launch(s : Vector2, g : Vector2):
	position = s
	goal = g+Vector2(0,-30)
	launched = true
	yield(self,"projectile_done")
	fade()
	cam.shake(0.5, 50, 10)
	var b = boom.instance()
	b.position = position
	root.add_child(b)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if launched:
		process_to_goal(delta*speed)

func process_to_goal(distance : float):
	var distance_to_target = position.distance_to(goal)
	
	if distance <= distance_to_target:
		position = position.linear_interpolate(goal,distance / distance_to_target)
	else :
		position = goal
		launched = false
		emit_signal("projectile_done",goal)

func fade():
	#get_parent().remove_child(self)
	self.queue_free()
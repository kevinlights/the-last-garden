extends Node2D

class_name Character

signal updated()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Play the next turn for the character
func update():
	emit_signal("updated")
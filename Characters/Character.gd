extends Node2D

signal updated()

class_name Character

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Play the next turn for the character
func update():
	emit_signal("updated")
extends Node2D

class_name Character

signal updated()

var is_insect : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	is_insect = false

# Play the next turn for the character
func update():
	emit_signal("updated")
extends Node2D

class_name Character

signal updated()

var type : String = "Character"
var is_insect : bool
var is_raflesia : bool = false
var is_ronce : bool = false
var to_remove : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_insect = false

# Play the next turn for the character
func update():
	emit_signal("updated")
	
func get_skill_zone():
	return []
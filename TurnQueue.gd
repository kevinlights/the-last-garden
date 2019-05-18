extends Node

signal turn_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Met a jour tous les characters
func play_turn():
	for child in get_characters(): 
		child.update()
		#yield(child,"updated")
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("turn_finished")

#Ajoute un character au jeu
func add_character(character):
	add_child(character)

#Renvois les characters dans le jeu
func get_characters():
	return get_children()
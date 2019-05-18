extends Node

signal turn_finished()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Met a jour tous les characters
func play_turn():
	for child in get_characters():
		child.update()
		yield(child,"updated")
	emit_signal("turn_finished")

#Ajoute un character au jeu
func add_character(character):
	add_child(character)

#Renvois les characters dans le jeu
func get_characters():
	return get_children()
	
func get_characers_positions():
	var positions : Array = Array()
	for character in get_characters():
		positions.append(character.global_position)
	return positions
	
func _on_insect_on():
	pass
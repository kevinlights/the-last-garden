extends Node2D

onready var tileMap : TileMap = $TileMap
onready var turnQueue : Node = $TurnQueue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play():
	while(true):
		# Selection et pose des graines
		# TODO
		# Jouer le tour
		turnQueue.play_turn()
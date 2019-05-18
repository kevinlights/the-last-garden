extends Node2D

onready var tileMap : TileMap = $TileMap
onready var turnQueue : Node = $TurnQueue
onready var ui_hud : CanvasLayer = $ui_hud
onready var ui_navigation : Node = $ui_navigation

var endTurn : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	play()

func play():
	var plant = null
	var tile : Vector2 = Vector2(-1,-1)
	
	while true:

		# Selection d'une graine
		# TODO : deselection
		ui_hud.select_plant()
		plant = yield(ui_hud,"plant_selected")
		print("selected plant:",plant)
		# Selection d'une case pour poser la graine
		# TODO : mauvaise selection et deselection
		ui_navigation.select_tile()
		tile = yield(ui_navigation,"tile_selected")
		print("selected tile :",tile)
		
		# Jouer le tour
		if endTurn :
			turnQueue.play_turn()
			yield(turnQueue,"turn_finished")
			endTurn = false

func _on_EndTurnButton_pressed():
	endTurn = true

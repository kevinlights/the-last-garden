extends Node2D

onready var tileMap : TileMap = $TileMap
onready var turnQueue : Node = $TurnQueue
onready var ui_hud : CanvasLayer = $ui_hud
onready var ui_navigation : Node = $ui_navigation

enum ETAT {
	SELECT_PLANT,
	SELECT_TILE,
	END_TURN
}

var etat_courant = ETAT.SELECT_PLANT
var selected_plant = null
var selected_tile : Vector2 = Vector2(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	play()

func play():
	while true:
		match etat_courant:
			ETAT.SELECT_PLANT:
				# Selection d'une graine
				# TODO : deselection
				ui_hud.select_plant()
				yield(ui_hud,"plant_selected")
				etat_courant = ETAT.SELECT_TILE if etat_courant != ETAT.END_TURN else etat_courant
				#print("selected plant:",selected_plant)
			ETAT.SELECT_TILE:
				# Selection d'une case pour poser la graine
				# TODO : mauvaise selection et deselection
				ui_navigation.select_tile()
				selected_tile = yield(ui_navigation,"tile_selected")
				etat_courant = ETAT.SELECT_PLANT if etat_courant != ETAT.END_TURN else etat_courant
				print("selected tile :",selected_tile)
			ETAT.END_TURN:
				turnQueue.play_turn()
				yield(turnQueue,"turn_finished")
				etat_courant = ETAT.SELECT_PLANT
				print("End turn")

func _on_EndTurnButton_pressed():
	etat_courant = ETAT.END_TURN

func _on_ui_hud_plant_selected(plant):
	if etat_courant in [ETAT.SELECT_TILE,ETAT.SELECT_PLANT]:
		selected_plant = plant
		print("selected plant:",selected_plant)

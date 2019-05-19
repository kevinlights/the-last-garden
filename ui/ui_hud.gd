extends CanvasLayer

signal plant_selected(plant)

var plant_selected : bool = false
var selected_plant = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# TODO : Connecter au bouttons
func select_plant():
	yield(self,"plant_selected")
	
func on_pissenlit_selected():
	selected_plant = "pissenlit"
	emit_signal("plant_selected",selected_plant)

func _on_RafflesiaButton_pressed():
	selected_plant = "rafflesia"
	emit_signal("plant_selected",selected_plant)

func _on_EndTurnButton_pressed():
	emit_signal("plant_selected","")

func _on_Game_mana_set(mana, manamax):
	$Graines/Mana.set_text(str(mana) + "/" + str(manamax))

func showVictoryScreen():
	$EcranFinDePartie.show()
	$EcranFinDePartie/VBoxContainer/CenterContainer/VICTOIRE.show()
	
func showDefeatScreen():
	$EcranFinDePartie.show()
	$EcranFinDePartie/VBoxContainer/CenterContainer/DEFAITE.show()

func _on_Rejouer_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_Retour_pressed():
	get_tree().change_scene("res://Menu.tscn")
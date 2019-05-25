extends CanvasLayer

signal plant_selected(plant)

var plant_selected : bool = false
var selected_plant = null

onready var boutonsPlantation : HBoxContainer = $BoutonsPlantation

onready var pissenlitButton_ressource = load("res://ui/PissenlitButton.tscn")
onready var rafflesiaButton_ressource = load("res://ui/RafflesiaButton.tscn")
onready var roncesButton_ressource = load("res://ui/RoncesButton.tscn")
onready var fleurBleueButtonButton_ressource = load("res://ui/FleurBleueButton.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# TODO : Connecter aux boutons
func select_plant():
	yield(self,"plant_selected")
	
func on_pissenlit_selected():
	selected_plant = "pissenlit"
	emit_signal("plant_selected",selected_plant)

func _on_RafflesiaButton_pressed():
	selected_plant = "rafflesia"
	emit_signal("plant_selected",selected_plant)

func _on_RoncesButton_pressed():
	selected_plant = "ronces"
	emit_signal("plant_selected",selected_plant)
	
func _on_FleurBleueButton2_pressed():
	selected_plant = "fleurbleue"
	emit_signal("plant_selected",selected_plant)

func _on_EndTurnButton_pressed():
	emit_signal("plant_selected","")

func _on_Game_mana_set(mana):
	$Graines/Mana.set_text(str(mana)+"/2")

func showInitialMessage():
	yield(get_tree().create_timer(0.5), "timeout")
	$MessageDebut.show()
	
	yield(get_tree().create_timer(4), "timeout")
	$MessageDebut.hide()
	$MessageDebut2.show()
	yield(get_tree().create_timer(5), "timeout")
	$MessageDebut2.hide()
	$MessageDebut3.show()
	
	yield(get_tree().create_timer(6), "timeout")
	$MessageDebut3.hide()
	$MessageDebut4.show()
	
	yield(get_tree().create_timer(4), "timeout")
	$MessageDebut4.hide()
	

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

func _on_PissenlitButton_mouse_entered():
	$PlanteDescription/VBoxContainer/Titre.set_text("Pissenlit")
	$PlanteDescription/VBoxContainer/Description.set_text("A l'éclosion: lance un pétale explosif sur un insecte.")
	$PlanteDescription/VBoxContainer/Cout.set_text("Cout : 1")
	$PlanteDescription/VBoxContainer/HatchTurns.set_text("Eclosion : 2 tours")
	$PlanteDescription/VBoxContainer/DieTurns.set_text("Flétrissement : 7 tours")
	$PlanteDescription.show()
	$EnergiePlanteDescription.show();

func _on_RafflesiaButton_mouse_entered():
	$PlanteDescription/VBoxContainer/Titre.set_text("Rafflesia")
	$PlanteDescription/VBoxContainer/Description.set_text("Attire les insectes vers elle.")
	$PlanteDescription/VBoxContainer/Cout.set_text("Cout : 1")
	$PlanteDescription/VBoxContainer/HatchTurns.set_text("Eclosion : 3 tours")
	$PlanteDescription/VBoxContainer/DieTurns.set_text("Flétrissement : 6 tours ")
	$PlanteDescription.show()
	$EnergiePlanteDescription.show();

func _on_RoncesButton_mouse_entered():
	$PlanteDescription/VBoxContainer/Titre.set_text("Ronces")
	$PlanteDescription/VBoxContainer/Description.set_text("Tue les insectes qui volent sur elle.")
	$PlanteDescription/VBoxContainer/Cout.set_text("Cout : 1")
	$PlanteDescription/VBoxContainer/HatchTurns.set_text("Eclosion : 3 tours")
	$PlanteDescription/VBoxContainer/DieTurns.set_text("Flétrissement : 5 tours")
	$PlanteDescription.show()
	$EnergiePlanteDescription.show();

func _on_FleurBleueButton_mouse_entered():
	$PlanteDescription/VBoxContainer/Titre.set_text("Fleur bleue")
	$PlanteDescription/VBoxContainer/Description.set_text("A l'éclosion: transforme des blocs en herbe pour pouvoir planter à nouveau.")
	$PlanteDescription/VBoxContainer/Cout.set_text("Cout : 1")
	$PlanteDescription/VBoxContainer/HatchTurns.set_text("Eclosion : 2 tours")
	$PlanteDescription/VBoxContainer/DieTurns.set_text("Flétrissement : 7 tours")
	$PlanteDescription.show()
	$EnergiePlanteDescription.show();

func _on_PissenlitButton_mouse_exited():
	$PlanteDescription.hide()
	$EnergiePlanteDescription.hide();

func _on_RafflesiaButton_mouse_exited():
	$PlanteDescription.hide()
	$EnergiePlanteDescription.hide();

func _on_RoncesButton_mouse_exited():
	$PlanteDescription.hide()
	$EnergiePlanteDescription.hide();

func _on_FleurBleueButton_mouse_exited():
	$PlanteDescription.hide()
	$EnergiePlanteDescription.hide();

func _on_Game_plants_changed(slots):
	for child in boutonsPlantation.get_children():
		boutonsPlantation.remove_child(child)
	var new_button
	for plant in slots:
		match plant:
			"pissenlit":
				new_button = pissenlitButton_ressource.instance()
			"rafflesia":
				new_button = rafflesiaButton_ressource.instance()
			"ronces":
				new_button = roncesButton_ressource.instance()
			"fleurbleue":
				new_button = fleurBleueButtonButton_ressource.instance()
		boutonsPlantation.add_child(new_button)


func _on_Game_plant_posee(slot):
	boutonsPlantation.remove_child(boutonsPlantation.get_children()[slot])

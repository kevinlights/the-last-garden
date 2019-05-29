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
	$MessageDebut/Panel/Message.set_text(tr("string_tuto1"))
	$MessageDebut2/Panel/Message.set_text(tr("string_tuto2"))
	$MessageDebut3/Panel/Message.set_text(tr("string_tuto3") + "\n" +  tr("string_tuto4"))
	$MessageDebut4/Panel/Message.set_text(tr("string_tuto5"))
	
	$"EndTurnButton/Fin de tour".set_text(tr("string_end_turn"))
	
	$EcranFinDePartie/VBoxContainer/CenterContainer/VICTOIRE.set_text("string_victory")
	$EcranFinDePartie/VBoxContainer/CenterContainer/DEFAITE.set_text("string_defeat")
	$EcranFinDePartie/VBoxContainer/HBoxContainer/Rejouer.set_text("string_rejouer")
	$EcranFinDePartie/VBoxContainer/HBoxContainer/Retour.set_text("string_retour")
	
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
	yield($MessageDebut/Panel/Button,"pressed")
	$MessageDebut.hide()
	
	$MessageDebut2.show()
	yield($MessageDebut2/Panel/Button,"pressed")
	$MessageDebut2.hide()
	
	$MessageDebut3.show()
	yield($MessageDebut3/Panel/Button,"pressed")
	$MessageDebut3.hide()
	
	$MessageDebut4.show()
	yield($MessageDebut4/Panel/Button,"pressed")
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
	$PlanteDescription/VBoxContainer/Titre.set_text(tr("string_daisy_name"))
	$PlanteDescription/VBoxContainer/Description.set_text(tr("string_daisy_description"))
	$PlanteDescription/VBoxContainer/Cout.set_text(tr("string_daisy_cost"))
	$PlanteDescription/VBoxContainer/HatchTurns.set_text(tr("string_daisy_blooming"))
	$PlanteDescription/VBoxContainer/DieTurns.set_text(tr("string_daisy_withering"))
	$PlanteDescription.show()
	$EnergiePlanteDescription.show();

func _on_RafflesiaButton_mouse_entered():
	$PlanteDescription/VBoxContainer/Titre.set_text(tr("string_rafflesia_name"))
	$PlanteDescription/VBoxContainer/Description.set_text(tr("string_rafflesia_description"))
	$PlanteDescription/VBoxContainer/Cout.set_text(tr("string_rafflesia_cost"))
	$PlanteDescription/VBoxContainer/HatchTurns.set_text(tr("string_rafflesia_blooming"))
	$PlanteDescription/VBoxContainer/DieTurns.set_text(tr("string_rafflesia_withering"))
	$PlanteDescription.show()
	$EnergiePlanteDescription.show();

func _on_RoncesButton_mouse_entered():
	$PlanteDescription/VBoxContainer/Titre.set_text(tr("string_thorn_bush_name"))
	$PlanteDescription/VBoxContainer/Description.set_text(tr("string_thorn_bush_description"))
	$PlanteDescription/VBoxContainer/Cout.set_text(tr("string_thorn_bush_cost"))
	$PlanteDescription/VBoxContainer/HatchTurns.set_text(tr("string_thorn_bush_blooming"))
	$PlanteDescription/VBoxContainer/DieTurns.set_text(tr("string_thorn_bush_withering"))
	$PlanteDescription.show()
	$EnergiePlanteDescription.show();

func _on_FleurBleueButton_mouse_entered():
	$PlanteDescription/VBoxContainer/Titre.set_text(tr("string_lily_flower_name"))
	$PlanteDescription/VBoxContainer/Description.set_text(tr("string_lily_flower_description"))
	$PlanteDescription/VBoxContainer/Cout.set_text(tr("string_lily_flower_cost"))
	$PlanteDescription/VBoxContainer/HatchTurns.set_text(tr("string_lily_flower_blooming"))
	$PlanteDescription/VBoxContainer/DieTurns.set_text(tr("string_lily_flower_withering"))
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
	plant_selected = false
	selected_plant = null
	$EcranFinDePartie/VBoxContainer/HBoxContainer/Rejouer.grab_focus()

extends MarginContainer

onready var langueSelector : OptionButton = get_parent().get_node("Langue")

func _ready():
	global.display_tutorial = true
	update_strings()
	get_parent().get_node("Langue").select(0)
	match TranslationServer.get_locale():
		"fr":
			langueSelector.select(0)
		"en":
			langueSelector.select(1)
		"eo":
			langueSelector.select(2)
	
func update_strings():
	$VBoxContainer/VBoxContainer/NouvellePartie.set_text(tr("string_new_game"))
	$VBoxContainer/Quitter.set_text(tr("string_quit"))
	$VBoxContainer/VBoxContainer/DisableTuto.set_text(tr("string_notuto"))
	
func _on_Nouvelle_Partie_pressed():
	get_tree().change_scene("res://Game.tscn")
	
func _on_Quitter_pressed():
	get_tree().quit()

func _on_Langue_item_selected(ID):
	match ID:
		0:
			TranslationServer.set_locale("fr")
		1:
			TranslationServer.set_locale("en")
		2:
			TranslationServer.set_locale("eo")
	update_strings()


func _on_DisableTuto_toggled(button_pressed):
	global.display_tutorial = not button_pressed

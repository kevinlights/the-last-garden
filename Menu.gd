extends MarginContainer


func _ready():
	update_strings()
	get_parent().get_node("Langue").select(1)
	match TranslationServer.get_locale():
		"fr":
			get_parent().get_node("Langue").select(0)
		"en":
			get_parent().get_node("Langue").select(1)
		"ht_HT":
			get_parent().get_node("Langue").select(2)
		"eo":
			get_parent().get_node("Langue").select(3)
	
func update_strings():
	$"VBoxContainer/Nouvelle Partie".set_text(tr("string_new_game"))
	$"VBoxContainer/Quitter".set_text(tr("string_quit"))
	
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
			TranslationServer.set_locale("ht_HT")
		3:
			TranslationServer.set_locale("eo")
	update_strings()

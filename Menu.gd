extends MarginContainer

func _ready():
	TranslationServer.set_locale("en")
	$"VBoxContainer/Nouvelle Partie".set_text(tr("string_new_game"))
	$"VBoxContainer/Quitter".set_text(tr("string_quit"))
	
func _on_Nouvelle_Partie_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_Regles_pressed():
	pass # Replace with function body.
	
func _on_Quitter_pressed():
	get_tree().quit()

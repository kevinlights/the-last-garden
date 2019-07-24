"""
Licensed under GPL-3.0-or-later
Copyright (C) 2019 Louka Soret

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

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

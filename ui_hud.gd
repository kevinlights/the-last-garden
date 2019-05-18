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
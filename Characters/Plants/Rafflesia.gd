extends Character

signal hatch_done_internal()

onready var longevite = get_node("RafflesiaSprite/Longevite")
onready var tileMap : TileMap = get_node("../../TileMap")
onready var turnQueue : Node = get_parent()

export var turns_to_hatch : int = 2
export var turns_to_fade : int = 7
export var attract_radius : int = 4

var sprites : Dictionary = {"seed":0,"adult_idle":1}
var current_turn : int = 0

func _ready():
	is_insect = false
	$RafflesiaSprite.frame = sprites["seed"]
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(turns_to_hatch - current_turn))

func update():
	yield(get_tree().create_timer(0.2), "timeout")

	if not to_remove:
		current_turn += 1
		if current_turn == turns_to_hatch:
			hatch()
			#yield(self, "hatch_done_internal")
		if current_turn == turns_to_fade:
			fade()
			
		#Update le label de longévité
		if current_turn < turns_to_hatch:
			longevite.set_text(str(turns_to_hatch - current_turn))
		else:
			var turnsBeforeFade : int = turns_to_fade - current_turn
			if turnsBeforeFade != 0:
				longevite.set_text(str(turnsBeforeFade))
	else:
		get_parent().remove_child(self)
		
	emit_signal("updated")
	
func hatch():
	longevite.set("custom_colors/font_color", Color(0.8,0,0))
	is_raflesia = true
	
	$RafflesiaSprite.frame = sprites["adult_idle"]
	
	emit_signal("hatch_done_internal")
	
func fade():
	longevite.set_text("")
	is_raflesia = false
	to_remove = true
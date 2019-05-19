extends Character

signal hatch_done_internal()

export var turns_to_hatch : int = 2
export var turns_to_fade : int = 4

var sprites : Dictionary = {"seed":0,"adult":1}
var current_turn : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	is_insect = false

# Play the next turn for the character
func update():
	yield(get_tree().create_timer(0.2), "timeout")
	if not to_remove:
		current_turn += 1
		if current_turn == turns_to_hatch:
			hatch()
			yield(self, "hatch_done_internal")
		if current_turn == turns_to_fade:
			fade()
			
		emit_signal("updated")
	else :
		emit_signal("updated")
		get_parent().remove_child(self)

func hatch():
	yield(get_tree().create_timer(0.2), "timeout")
	#TODO changer les cases sur la meme ligne et meme column en herbe
	emit_signal("hatch_done_internal")

func fade():
	to_remove = true
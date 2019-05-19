extends Character

signal hatch_done_internal()

export var turns_to_hatch : int = 1
export var turns_to_fade : int = 4

var sprites : Dictionary = {"seed":0,"adult":1}
var current_turn : int = 0

func _ready():
	$RonceSprite.frame = sprites["seed"]
	is_insect = false

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
		is_ronce = false
		get_parent().remove_child(self)

func hatch():
	yield(get_tree().create_timer(0.2), "timeout")
	$RonceSprite.frame = sprites["adult"]
	is_ronce = true
	emit_signal("hatch_done_internal")

func fade():
	to_remove = true
extends Character

var turns_to_hatch : int = 3
var turns_to_fade : int = 4

var sprites :Dictionary = {"icon":0,"seed":1,"adult_idle":2,"adult_wink":3}
var current_turn : int = 0

func _ready():
	$Sprite2.frame = sprites["seed"]
	$Sprite2.material = $Sprite2.material.duplicate();

func process(delta):
	pass

func update():
	# Timer pour le yield (pas beau)
	yield(get_tree().create_timer(0.2), "timeout")
	current_turn += 1
	if current_turn == turns_to_hatch:
		hatch()
	if current_turn == turns_to_fade:
		fade()
	emit_signal("updated")

# La plante eclos
func hatch():
	$AnimationPlayer.play("metamorphose")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
	#frame = sprites["adult_idle"]

# La plante disparais
func fade():
	$AnimationPlayer.play("meurt")
	yield($AnimationPlayer, "animation_finished")
	get_parent().remove_child(self)
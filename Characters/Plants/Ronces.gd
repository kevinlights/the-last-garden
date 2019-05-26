extends Character

signal hatch_done_internal()

onready var sprite : Sprite = $RonceSprite
onready var tileMap : TileMap = get_node("../../TileMap")
onready var longevite = get_node("RonceSprite/Longevite")

export var turns_to_hatch : int = 3
export var turns_to_fade : int = 5

var sprites : Dictionary = {"seed":0,"adult":1}
var current_turn : int = 0

func _ready():
	$RonceSprite.frame = sprites["seed"]
	type = "Ronce"
	is_insect = false
	$RonceSprite.material = $RonceSprite.material.duplicate();
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(turns_to_hatch - current_turn))

func update():
	yield(get_tree().create_timer(0.2), "timeout")
	if not to_remove:
		current_turn += 1
		if current_turn == turns_to_hatch:
			hatch()
			yield(self, "hatch_done_internal")
		if current_turn == turns_to_fade:
			fade()
			
		#Update le label de longévité
		if current_turn < turns_to_hatch:
			longevite.set_text(str(turns_to_hatch - current_turn))
		else:
			var turnsBeforeFade : int = turns_to_fade - current_turn
			if turnsBeforeFade != 0:
				longevite.set_text(str(turnsBeforeFade))
		emit_signal("updated")
	else :
		emit_signal("updated")
		is_ronce = false
		get_parent().remove_child(self)

func hatch():
	$AnimationPlayer.play("meta")
	yield(get_tree().create_timer(0.2), "timeout")
	#$RonceSprite.frame = sprites["adult"]
	is_ronce = true
	
	longevite.set("custom_colors/font_color", Color(0.8,0,0))
	emit_signal("hatch_done_internal")

func fade():
	longevite.set_text("")
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimationPlayer.play("meurt")
	yield($AnimationPlayer, "animation_finished")
	to_remove = true

func get_skill_zone():
	return [tileMap.world_to_map(global_position)]

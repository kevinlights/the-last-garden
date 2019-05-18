extends Character

signal game_won()
signal game_lost()

onready var longevite = $PlanteMereSprite/Longevite

var beginningLevel : int = 15
var currentLevel : int = beginningLevel

var to_remove : int = false

func _ready():
	is_insect = false
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(currentLevel))
	
func update():
	if not to_remove:
		yield(get_tree().create_timer(0.2), "timeout")
		currentLevel -= 1
		longevite.set_text(str(currentLevel))
		if(currentLevel == 0):
			hatch()
		emit_signal("updated")
	else :
		emit_signal("updated")
		emit_signal("game_lost")
		get_parent().remove_child(self)
	
func hatch():
	emit_signal("game_won")
	
func fade():
	to_remove = true

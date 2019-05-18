extends Character

var level : int = 1
var levelToReach : int = 15
onready var longevite = get_node("PlanteMereSprite/Longevite")

func _ready():
	is_insect = false
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(level))
	
func _update():
	yield(get_tree().create_timer(0.2), "timeout")
	level += 1
	
	longevite.set_text(str(level))
	
	if(level == levelToReach):
		hatch()
	
	emit_signal("updated")
	
func hatch():
	emit_signal("game_won")

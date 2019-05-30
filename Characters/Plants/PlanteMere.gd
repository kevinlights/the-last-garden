extends Character

signal game_won()
signal game_lost()

onready var soundsMusique : Node = get_node("../../Sounds/Musique")
onready var soundsMusiqueVictoire : Node = get_node("../../Sounds/MusiqueVictoire")

export var beginningLevel : int = 1 #20

onready var longevite = $PlanteMereSprite/Longevite
var currentLevel : int = beginningLevel
onready var tm = get_tree().get_root().get_node("Game/TileMap")
onready var terrain = get_tree().get_root().get_node("Game/TileMap/terrain")
onready var tq = get_tree().get_root().get_node("Game/TurnQueue")

func _ready():
	is_insect = false
	is_mere = true
	connect('game_won', get_parent().get_parent(), '_on_game_won')
	connect('game_lost', get_parent().get_parent(), '_on_game_lost')
	longevite.set("custom_colors/font_color", Color(0,0,0.8))
	longevite.set_text(str(currentLevel))
	$AnimationPlayer.play("idle")
	
func update():
	if not to_remove:
		yield(get_tree().create_timer(0.2), "timeout")
		currentLevel -= 1
		longevite.set_text(str(currentLevel))
		if(currentLevel == 0):
			hatch()
			yield(self,"game_won")
		emit_signal("updated")
	else :
		emit_signal("updated")
		get_parent().remove_child(self)
	
func hatch():
	soundsMusique.stop()
	soundsMusiqueVictoire.play()
	$AnimationPlayer.playback_speed = 0.5
	$AnimationPlayer.play("eclosion")
	longevite.set_text("")
	tq.kill_all_insect()
	yield(get_tree().create_timer(0.2), "timeout")
	for v in tm.get_used_cells():
		terrain.getBloc(v).uncorrupt()
	yield($AnimationPlayer, "animation_finished")
	emit_signal("game_won")
	
func fade():
	$AnimationPlayer.play("meurt")
	emit_signal("game_lost")
	yield($AnimationPlayer, "animation_finished")
	to_remove = true

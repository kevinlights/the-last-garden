extends Sprite

signal projectile_done(position)

onready var root : Node2D = get_parent().get_parent()
onready var turnQueue : Node = get_node("../TurnQueue")
onready var cam : Camera2D = get_node("../Camera2D")
var boom = load("res://boom.tscn")

export var speed : int = 500

var goal : Vector2
var launched : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("projectile_done", turnQueue, "_on_projectile_done")

func launch(s : Vector2, g : Vector2):
	position = s
	goal = g+Vector2(0,-30)
	launched = true
	yield(self,"projectile_done")
	fade()
	cam.shake(0.5, 50, 10)
	var b = boom.instance()
	b.position = position
	root.add_child(b)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if launched:
		process_to_goal(delta*speed)

func process_to_goal(distance : float):
	var distance_to_target = position.distance_to(goal)
	
	if distance <= distance_to_target:
		position = position.linear_interpolate(goal,distance / distance_to_target)
	else :
		position = goal
		launched = false
		emit_signal("projectile_done",goal)

func fade():
	get_parent().remove_child(self)
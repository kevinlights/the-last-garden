extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isCorrupted = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$grass.material = $grass.material.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func uncorrupt():
	if(isCorrupted):
		isCorrupted = false
		$AnimationPlayer.play("uncorrupt")
		

func corrupt():
	if(!isCorrupted):
		isCorrupted = true
		$AnimationPlayer.play("corrupt")
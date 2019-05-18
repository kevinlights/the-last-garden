extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bloc_ressource = load("res://bloc/Bloc.tscn")
var d : Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	var tm : TileMap= get_parent()
	var blocs : Array

	for v in tm.get_used_cells():
		var go = bloc_ressource.instance()
		go.position = tm.map_to_world(v) + Vector2(0,tm.cell_size.y)
		self.add_child(go)
		d[v] = go
		
func getBloc(v):
	return d[v]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

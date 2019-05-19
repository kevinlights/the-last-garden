extends Character

signal hatch_done_internal()

onready var tileMap : TileMap = get_node("../../TileMap")
onready var terrain  = get_node("../../TileMap/terrain")

export var turns_to_hatch : int = 2
export var turns_to_fade : int = 4

var sprites : Dictionary = {"seed":1,"adult":2}
var skill_directions : Array = [Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1)]
var current_turn : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$FleurBleuSprite.frame = sprites["seed"]
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
	
	$FleurBleuSprite.frame = sprites["adult"]
	
	var current_tile : Vector2 
	var i : int = 1
	for direction in skill_directions:
		current_tile = tileMap.world_to_map(global_position) + direction
		i = 1
		while current_tile in tileMap.get_used_cells():
			terrain.getBloc(current_tile).uncorrupt()
			current_tile = tileMap.world_to_map(global_position) + direction*i
			i += 1
	
	emit_signal("hatch_done_internal")

func fade():
	to_remove = true
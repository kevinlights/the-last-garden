extends Character

signal goal_reached()
signal insect_on(position)

onready var tileMap : TileMap = get_node("../../TileMap")
onready var turnQueue : Node = get_parent()

export var speed = 200
export var turns_to_hatch : int = 2

var sprites :Dictionary = {"seed":0,"adult_bottomLeft":1,"adult_topLeft":2}
var current_turn : int = 0
var target_character : Vector2 = Vector2()
var target_tile : Vector2 = Vector2()
var move_to_tile : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#frame = sprites["seed"]
	is_insect = true
	connect("insect_on", turnQueue, "_on_insect_on")
	$insectotueur.frame = sprites["seed"]

func _process(delta):
	if move_to_tile:
		go_to_target_tile(speed * delta)

# Play the next turn for the character
func update():
	yield(get_tree().create_timer(0.2), "timeout")
	current_turn += 1
	
	if current_turn == turns_to_hatch:
		hatch()
		yield(self,"goal_reached")
		move_to_tile = false
	if current_turn > turns_to_hatch:
		var path = tileMap.get_astar_path(global_position, target_character)
		target_tile = path[1]
		print("current: ",tileMap.world_to_map(path[0]))
		emit_signal("insect_on",tileMap.world_to_map(target_tile))
		change_orientation(tileMap.world_to_map(target_tile-global_position))
		move_to_tile = true
		yield(self,"goal_reached")
		move_to_tile = false
	emit_signal("updated")

func go_to_target_tile(distance : float):
	var distance_to_target = position.distance_to(target_tile)
	
	if distance <= distance_to_target:
		position = position.linear_interpolate(target_tile,distance / distance_to_target)
	else :
		position = target_tile
		move_to_tile = false
		emit_signal("goal_reached")

func set_target(character : Vector2):
	target_character = character

func change_orientation(direction : Vector2):
	var topLeft : Vector2 = Vector2(-1,0)
	var topRight : Vector2 = Vector2(0,-1)
	var bottomLeft : Vector2 = Vector2(0,1)
	var bottomRight : Vector2 = Vector2(1,0)
	
	if direction == topLeft:
		$insectotueur.frame = sprites["adult_topLeft"]
		$insectotueur.flip_h = false
	if direction == topRight:
		$insectotueur.frame = sprites["adult_topLeft"]
		$insectotueur.flip_h = true
	if direction == bottomLeft:
		$insectotueur.frame = sprites["adult_bottomLeft"]
		$insectotueur.flip_h = false
	if direction == bottomRight:
		$insectotueur.frame = sprites["adult_bottomLeft"]
		$insectotueur.flip_h = true

func hatch():
	
	var topLeft : Vector2 = Vector2(-1,0)
	var topRight : Vector2 = Vector2(0,-1)
	var bottomLeft : Vector2 = Vector2(0,1)
	var bottomRight : Vector2 = Vector2(1,0)
	
	var tile : Vector2 = tileMap.world_to_map(global_position)
	$AnimationPlayer.play("fly")
	if tile + topLeft in tileMap.get_used_cells():
		target_tile = tileMap.map_to_world(tile + topLeft) + Vector2(0,tileMap.cell_size.y/2)
		$insectotueur.frame = sprites["adult_topLeft"]
		$insectotueur.flip_h = false
		move_to_tile = true
	elif tile + topRight in tileMap.get_used_cells():
		target_tile = tileMap.map_to_world(tile + topRight) + Vector2(0,tileMap.cell_size.y/2)
		$insectotueur.frame = sprites["adult_topLeft"]
		$insectotueur.flip_h = true
		move_to_tile = true
	elif tile + bottomLeft in tileMap.get_used_cells():
		target_tile = tileMap.map_to_world(tile + bottomLeft) + Vector2(0,tileMap.cell_size.y/2)
		$insectotueur.frame = sprites["adult_bottomLeft"]
		$insectotueur.flip_h = false
		move_to_tile = true
	elif tile + bottomRight in tileMap.get_used_cells():
		target_tile = tileMap.map_to_world(tile + bottomRight) + Vector2(0,tileMap.cell_size.y/2)
		$insectotueur.frame = sprites["adult_bottomLeft"]
		$insectotueur.flip_h = true
		move_to_tile = true
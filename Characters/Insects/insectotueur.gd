extends Character

signal goal_reached()
signal insect_on(position)

onready var tileMap : TileMap = get_node("../../TileMap")
onready var terrain  = get_node("../../TileMap/terrain")
onready var turnQueue : Node = get_parent()

export var speed = 200
export var turns_to_hatch : int = 1

var sprites :Dictionary = {"seed":0,"adult_bottomLeft":1,"adult_topLeft":2}
var current_turn : int = 0
var target_character : Vector2 = Vector2()
var target_tile : Vector2 = Vector2()
var move_to_tile : bool = false
var ronce_die : bool = false
onready var longevite = get_node("insectotueur/Longevite")

# Called when the node enters the scene tree for the first time.
func _ready():
	#frame = sprites["seed"]
	type = "Insect"
	is_insect = true
	connect("insect_on", turnQueue, "_on_insect_on")
	$insectotueur.frame = sprites["seed"]
	$insectotueur.material = $insectotueur.material.duplicate();
	longevite.set_text(str(turns_to_hatch - current_turn))
	terrain.getBloc(tileMap.world_to_map(position)).corrupt()

func _process(delta):
	if move_to_tile:
		go_to_target_tile(speed * delta)

# Play the next turn for the character
func update():
	yield(get_tree().create_timer(0.2), "timeout")
	current_turn += 1
	
	if current_turn < turns_to_hatch:
		longevite.set_text(str(turns_to_hatch - current_turn))
		
	if current_turn == turns_to_hatch:
		hatch()
		yield(self,"goal_reached")
		if ronce_die:
			fade()
		move_to_tile = false
	if current_turn > turns_to_hatch:
		var potential_target = turnQueue.find_closest_raflesia(global_position)
		target_character = potential_target
		target_tile = movement_predictor()
		ronce_die = turnQueue.contain_ronce(target_tile)
		emit_signal("insect_on",tileMap.world_to_map(target_tile))
		change_orientation(tileMap.world_to_map(target_tile-global_position))
		move_to_tile = true
		yield(self,"goal_reached")
		if ronce_die:
			fade()
		move_to_tile = false
	emit_signal("updated")

func go_to_target_tile(distance : float):
	var distance_to_target = position.distance_to(target_tile)
	
	if distance <= distance_to_target:
		position = position.linear_interpolate(target_tile,distance / distance_to_target)
	else :
		position = target_tile
		move_to_tile = false
		terrain.getBloc(tileMap.world_to_map(position)).corrupt()
		emit_signal("goal_reached")

func movement_predictor():
	var current_tile : Vector2 = tileMap.world_to_map(global_position)
	var tile : Vector2 = tileMap.world_to_map(target_character)
	var distances : Array = Array()
	var candidat : Array
	var distance : int
	for direction in [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]:
		distance = tile.distance_to(current_tile+direction)
		distances.append([distance,current_tile+direction])
	distances.sort_custom(self,"distance_sort")
	candidat = distances.pop_front()
	while(turnQueue.contain_enemy(candidat[1]) and not distances == []):
		candidat = distances.pop_front()
	
	if ((turnQueue.contain_enemy(candidat[1]) and distances == []) or candidat[0] > tile.distance_to(current_tile)):
		candidat = [-1,current_tile]
	
	if not (candidat[1] in tileMap.get_used_cells()):
		candidat = [-1,current_tile]
	
	return tileMap.map_to_world(candidat[1]) + Vector2(0,tileMap.cell_size.y/2)

func distance_sort(a : Array, b : Array) -> bool:
	return a[0] < b[0]

func set_target(character : Vector2):
	target_character = character

func change_orientation(direction : Vector2):
	if direction == Vector2.UP:
		$insectotueur.frame = sprites["adult_topLeft"]
		$insectotueur.flip_h = true
	if direction == Vector2.LEFT:
		$insectotueur.frame = sprites["adult_topLeft"]
		$insectotueur.flip_h = false
	if direction == Vector2.RIGHT:
		$insectotueur.frame = sprites["adult_bottomLeft"]
		$insectotueur.flip_h = true
	if direction == Vector2.DOWN:
		$insectotueur.frame = sprites["adult_bottomLeft"]
		$insectotueur.flip_h = false

func hatch():
	var tile : Vector2 = tileMap.world_to_map(global_position)
	var direction : Vector2
	
	target_tile = movement_predictor()
	ronce_die = turnQueue.contain_ronce(target_tile)
	direction = tile.direction_to(tileMap.world_to_map(target_tile))
	
	$AnimationPlayer.play("fly")
	
	emit_signal("insect_on",tileMap.world_to_map(target_tile))
	change_orientation(direction)
	move_to_tile = true
	
	longevite.set_text(str(""))
	
func fade():
	$AnimationPlayer.play("meurt")
	yield($AnimationPlayer, "animation_finished")
	to_remove = true
	get_parent().remove_child(self)
	longevite.set_text(" ")
	
func get_skill_zone():
	return [tileMap.world_to_map(movement_predictor())]
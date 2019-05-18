extends Character

onready var tileMap : TileMap = get_node("../../TileMap")
onready var turnQueue : Node = get_parent()
onready var root : Node2D = get_parent().get_parent()

var projectile_ressource = load("res://Characters/Plants/Projectile.tscn")

export var turns_to_hatch : int = 2
export var turns_to_fade : int = 4
export var attack_radius : int = 1

var sprites : Dictionary = {"icon":0,"seed":1,"adult_idle":2,"adult_wink":3}
var shoot_zone : Array = [Vector2(0,1),Vector2(-1,0),Vector2(0,1),Vector2(0,-1),   # radius = 1 
						  Vector2(1,1),Vector2(-1,-1),Vector2(-1,1),Vector2(1,-1)] # radius = 2 (diagonals)
var current_turn : int = 0

func _ready():
	is_insect = false
	$Sprite2.frame = sprites["seed"]
	$Sprite2.material = $Sprite2.material.duplicate();

func process(delta):
	pass

func update():
	# Timer pour le yield (pas beau)
	yield(get_tree().create_timer(0.2), "timeout")
	current_turn += 1
	if current_turn == turns_to_hatch:
		hatch()
	if current_turn == turns_to_fade:
		fade()
	emit_signal("updated")

# La plante eclos
func hatch():
	var new_projectile
	
	$AnimationPlayer.play("metamorphose")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
	
	for i in range(attack_radius):
		for offset in shoot_zone:
			var tile : Vector2 = tileMap.world_to_map(global_position) + offset*(i+1)
			if turnQueue.contain_enemy(tile):
				new_projectile = projectile_ressource.instance()
				root.add_child(new_projectile)
				new_projectile.launch(position, tileMap.map_to_world(tile) + Vector2(0,tileMap.cell_size.y/2))
				yield(new_projectile, "projectile_done")
				break
	#frame = sprites["adult_idle"]

# La plante disparais
func fade():
	$AnimationPlayer.play("meurt")
	yield($AnimationPlayer, "animation_finished")
	get_parent().remove_child(self)
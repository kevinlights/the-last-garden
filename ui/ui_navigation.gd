extends Node

signal tile_selected(tile)

onready var tileMap : TileMap = get_node("../NavMap")
onready var mouse : Sprite = $Mouse

var selecting_tile : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if selecting_tile:
				var tile : Vector2 = tileMap.world_to_map(mouse.global_position)
				emit_signal("tile_selected",tile)
				get_tree().set_input_as_handled()
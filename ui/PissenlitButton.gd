extends TextureButton

onready var ui_hud : CanvasLayer = get_node("../..")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", ui_hud, "on_pissenlit_selected")
	connect("mouse_entered", ui_hud, "_on_PissenlitButton_mouse_entered")
	connect("mouse_exited", ui_hud, "_on_RafflesiaButton_mouse_exited")
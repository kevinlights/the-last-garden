extends TextureButton

onready var ui_hud : CanvasLayer = get_node("../..")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", ui_hud, "_on_FleurBleueButton2_pressed")
	connect("mouse_entered", ui_hud, "_on_FleurBleueButton_mouse_entered")
	connect("mouse_exited", ui_hud, "_on_FleurBleueButton_mouse_exited")
extends Node2D


onready var player = $Player
onready var camera = $Game_camera

onready var fx_container = $FX_container



# Set up
func _ready():
	camera.initialize(player)
	player.initialize(fx_container)

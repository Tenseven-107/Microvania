extends Node2D


onready var player = $Player
onready var camera = $Game_camera



# Set up
func _ready():
	camera.initialize(player)

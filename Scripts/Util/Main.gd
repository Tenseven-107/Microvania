extends Node2D


onready var player = $Player
onready var camera = $Camera2D



# Set up
func _ready():
	camera.initialize(player)

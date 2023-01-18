extends Node2D


onready var player = $Player
onready var camera = $Game_camera
onready var rng = $Loot_generator

onready var enemy_container = $Enemy_container
onready var fx_container = $FX_container
onready var item_container = $Item_container
onready var projectile_container = $Projectile_container



# Set up
func _ready():
	camera.initialize(player)
	player.initialize(fx_container, projectile_container)
	enemy_container.initialize(fx_container)
	rng.initialize(item_container)

	MusicPlayer.play_song(0)

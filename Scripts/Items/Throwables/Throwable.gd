extends Node2D


onready var cooldown = $Cooldown

export (PackedScene) var projectile: PackedScene

var projectile_container = null

var team: int = 0



# Throw projectile
func attack():
	if cooldown.is_stopped():
		var instance = projectile.instance()

		instance.global_transform = global_transform
		instance.team = self.team
		projectile_container.call_deferred("add_child", instance)

		cooldown.start()



func get_if_stopped():
	if cooldown.is_stopped():
		return true



# Initialization
func initialize(pro_cont):
	self.projectile_container = pro_cont

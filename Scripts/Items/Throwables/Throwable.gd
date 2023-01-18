extends Node2D



export (PackedScene) var projectile: PackedScene

var projectile_container = null



# Throw projectile
func attack():
	var instance = projectile.instance()
	instance.global_position = global_position
	projectile_container.call_deferred("add_child", instance)



# Initialization
func initialize(pro_cont):
	self.projectile_container = pro_cont

extends Node2D


var fx_container


func initialize(fx_cont):
	self.fx_container = fx_cont

	var enemies = get_children()
	for enemy in enemies:
		enemy.initialize(fx_container)

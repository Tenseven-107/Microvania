extends Node
class_name Loot_generator


export (int) var max_number: int = 5


var items: Dictionary = {
	#"name": {object, chance}
	0: {"object": null, "chance": 6},
	1: {"object": preload("res://Prefabs/Items/Misc/HP_pickup.tscn"), "chance": 2},
	2: {"object": preload("res://Prefabs/Items/Misc/Big_HP_pickup.tscn"), "chance": 1}
}


var item_container = null


func _ready():
	randomize()

	GlobalSignals.connect("spawn_item", self, "spawn")



# Spawn item
func spawn(pos):
	var picked_item = pick()

	if picked_item:
		var instance = picked_item.instance()
		instance.global_position = pos
		item_container.call_deferred("add_child", instance)



#  Pick item
func pick():
	var total_chance: int = 0
	var done: bool = false
	var all_items = items.values()
	var size = items.size()

	for item in size:
		var item_data = all_items[item]
		var chance = item_data.get("chance", null)
		total_chance += chance

		if item == (size - 1):
			done = true

	if done:
		for item in size:
			var random_number: int = int(rand_range(0, total_chance))

			var gotten_item = all_items[item].get("object", null)
			var item_chance = all_items[item].get("chance", null)

			if total_chance and item_chance >= random_number and item_chance <= random_number:
				return gotten_item



# Initialization
func initialize(item_cont):
	self.item_container = item_cont








extends Node
class_name Loot_generator


export (int) var max_number: int = 5


var items: Dictionary = {
	#"name": {object, chance}
	0: {"object": null, "chance": 5},
	1: {"object": preload("res://Prefabs/Items/Misc/HP_pickup.tscn"), "chance": 5},
	2: {"object": preload("res://Prefabs/Items/Misc/Big_HP_pickup.tscn"), "chance": 2}
}


var item_container = null


func _ready():
	randomize()

	GlobalSignals.connect("spawn_item", self, "spawn")



# Spawn item
func spawn(pos):
	print(pick())



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
		var random_number: int = int(rand_range(0, total_chance))

		for item in size:
			var gotten_item = all_items[item].get("object", null)
			var item_chance = all_items[item].get("chance", null)

			if total_chance and item_chance > random_number:
				return gotten_item

			else:
				return null



# Initialization
func initialize(item_cont):
	self.item_container = item_cont








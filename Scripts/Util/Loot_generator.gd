extends Node
class_name Loot_generator


export (int) var max_number: int = 5
export (Array, PackedScene) var items: Array

var item_container = null


func _ready():
	randomize()

	items.resize(max_number)

	GlobalSignals.connect("spawn_item", self, "spawn")



# Spawn item
func spawn(pos):
	var picked_number = pick()

	if picked_number:
		var inst = items[picked_number].instance()
		inst.global_position = pos

		item_container.call_deferred("add_child", inst)



#  Pick item
func pick():
	if items.size() > 0:
		var number: int = int(rand_range(0, max_number))
		var picked_item

		items.shuffle()
		if items[number] != null:
			picked_item = number
		return picked_item





# Initialization
func initialize(item_cont):
	self.item_container = item_cont








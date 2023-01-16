extends Node
class_name RNG


export (int) var max_number: int = 10
export (Array, PackedScene) var items: Array



func _ready():
	randomize()

	items.resize(max_number)

	GlobalSignals.connect("spawn_item", self, "spawn")


func _process(delta):
	if Input.is_action_pressed("attack"):
		print(pick())



# Spawn_item
func spawn_item():
	pick()



#  Pick item
func pick():
	if items.size() > 0:
		var number: int = int(rand_range(0, max_number))
		var picked_item

		items.shuffle()
		if range(items.size()).has(number):
			picked_item = number
			return picked_item

		else:
			picked_item = null










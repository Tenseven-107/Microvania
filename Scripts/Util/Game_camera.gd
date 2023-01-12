extends Camera2D


var grid_size: Vector2
var grid_pos: Vector2

var player = null


# Set up
func _ready():
	grid_size = Vector2(128, 128) # Insert window size
	set_as_toplevel(true)
	update_cam(Vector2(0,0))


func update_cam(pos):
	var x = round(pos.x / grid_size.x)
	var y = round(pos.y / grid_size.y)
	var new_grid_pos = Vector2(x, y)

	if grid_pos == new_grid_pos:
		return

	grid_pos = new_grid_pos
	position = grid_pos * grid_size



func _on_Area2D_body_exited(body: Player):
	if is_instance_valid(player):
		if body == player:
			update_cam(body.global_position)



# Initialization
func initialize(player_obj):
	self.player = player_obj










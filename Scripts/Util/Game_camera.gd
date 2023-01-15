extends Camera2D


onready var screenshake_tween = $Screenshake_tween
onready var screenshake_timer = $Screenshake_timer

onready var hitstop_tween = $Hitstop_tween
onready var hitstop_timer = $Hitstop_timer


var grid_size: Vector2
var grid_pos: Vector2

var player = null


# Set up
func _ready():
	grid_size = Vector2(128, 128) # Insert window size
	set_as_toplevel(true)
	update_cam(Vector2(0,0))

	GlobalSignals.connect("screenshake", self, "shake_screen")
	GlobalSignals.connect("hitstop", self, "hit_stop")


# Room view
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



# Screenshake
func shake_screen(power, time):
	screenshake_timer.wait_time = time

	var x = rand_range(-power, power)
	var y = rand_range(-power, power)
	var cam_offset: Vector2 = Vector2(x, y)

	screenshake_tween.interpolate_property(self, "offset", offset, cam_offset, time, 
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	screenshake_tween.start()
	screenshake_timer.start()


func _on_Screenshake_timer_timeout():
	screenshake_tween.interpolate_property(self, "offset", offset, Vector2(0,0), 0.01, 
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	screenshake_tween.start()



# Hitstop
func hit_stop(time):
	hitstop_timer.wait_time = time

	hitstop_tween.interpolate_property(Engine, "time_scale", 0.1, 1, time, 
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	hitstop_tween.start()
	hitstop_timer.start()


func _on_Hitstop_timer_timeout():
	Engine.time_scale = 1



# Initialization
func initialize(player_obj):
	self.player = player_obj















extends KinematicBody2D



export (PackedScene) var pickup: PackedScene

onready var collider = $CollisionShape2D
onready var vis = $VisibilityNotifier2D
onready var respawn_timer = $Respawn_timer

export (int) var hp: int = 1
export (int) var max_hp: int = 1
export (int) var team: int = 1

export (float) var gravity: float = 100
export (float) var max_fall_speed: float = 300
var motion: Vector2
var pos: Vector2

var active: bool = false
var dead: bool = false



# Set up
func _ready():
	pos = global_position

	GlobalSignals.connect("init_crates", self, "initialize")
	vis.connect("screen_entered", self, "enable_disable")
	vis.connect("screen_exited", self, "enable_disable")



# Processing
func _physics_process(delta):
	# Gravity
	motion.y += gravity
	if motion.y > max_fall_speed:
		motion.y  = max_fall_speed

	motion = move_and_slide(motion, Vector2.UP)



# Taking damage
func handle_hit(value, _null_value):
	hp -= value

	if hp <= 0:
		die()

func die():
	respawn_timer.start()
	collider.set_deferred("disabled", true)

	dead = true
	hide()

	spawn()



# Spawn instances
func spawn():
	var pickup_inst = pickup.instance()
	pickup.global_position = global_position
	



# Enable_disable
func enable_disable():
	if !active:
		active = true

		# Respawn Enemy
		if respawn_timer.is_stopped() and dead:
			hp = max_hp
			dead = false

			collider.set_deferred("disabled", false)
			global_position = pos

			show()

	else:
		active = false

		# If still dead, dont respawn
		if !respawn_timer.is_stopped() and dead:
			respawn_timer.start()
			dead = true

			collider.set_deferred("disabled", true)
			global_position = pos

			hide()

	set_physics_process(active)




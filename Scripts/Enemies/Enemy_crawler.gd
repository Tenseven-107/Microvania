extends KinematicBody2D



onready var sprite = $AnimatedSprite

onready var vis = $VisibilityNotifier2D
onready var damage_zone = $Damage_zone

onready var respawn_timer = $Respawn_timer

onready var anims = $Anims
onready var appear_sfx = $SFX/RandomAudioStreamPlayer2D3

var fx_container = null


# Fx
export (PackedScene) var dead_fx: PackedScene


# Combat variables
export (int) var max_hp: int = 2
var hp: int = 2
export (int) var team: int = 1

# Movement Variables
export (float) var max_speed: float = 10

var velocity: Vector2
var move: Vector2
var rotating: int

# Checks
var active: bool = false
var dead: bool = false



# Set up
func _ready():
	damage_zone.team = self.team

	hp = max_hp

	set_physics_process(active)
	damage_zone.set_process(active)

	vis.connect("screen_entered", self, "enable_disable")
	vis.connect("screen_exited", self, "enable_disable")



# Movement
func _physics_process(delta):
	if respawn_timer.is_stopped() and !dead:
		sprite.playing = true

		if rotating:
			rotation = lerp_angle(rotation, velocity.angle(), 0.5)
			rotating -= 1

			return

		var collision = move_and_collide(move * max_speed * delta)
		if collision and collision.normal.rotated(PI/2).dot(move) < 0.5:
			rotating = 4
			move = collision.normal.rotated(PI/2)

			return

		var pos = position
		collision = move_and_collide(move.rotated(PI/2) * 15)

		if not collision:
			for i in 10:
				position = pos
				rotate(PI/32)

				move = move.rotated(PI/32)
				collision = move_and_collide(move.rotated(PI/2) * 15)

				if collision:
					move = collision.normal.rotated(PI/2)
					rotation = move.angle()

					break

		else:
			move = collision.normal.rotated(PI/2)
			rotation = move.angle()
		# Place the enemy at the edge of a platue one pixel deep.



# Taking damage
func handle_hit(damage):
	if respawn_timer.is_stopped() and !dead:
		hp -= damage

		anims.play("Hit")

		if hp <= 0:
			die()


func die():
	respawn_timer.start()
	dead = true
	damage_zone.can_damage = false

	GlobalSignals.emit_signal("spawn_item", global_position)

	var dead_inst =  dead_fx.instance()
	dead_inst.global_position = global_position
	fx_container.call_deferred("add_child", dead_inst)
	anims.play("Dead")

	hide()



# Enable disable functions
func enable_disable():
	if !active:
		active = true

		appear_sfx.play()

		# Respawn Enemy
		if respawn_timer.is_stopped() and dead:
			hp = max_hp
			dead = false
			damage_zone.can_damage = true
			show()

	else:
		active = false

		# If still dead, dont respawn
		if respawn_timer.is_stopped() and dead:
			respawn_timer.start()
			dead = true
			damage_zone.can_damage = false
			hide()

	set_physics_process(active)
	damage_zone.set_process(active)



# Initialization
func initialize(fx_cont):
	self.fx_container = fx_cont



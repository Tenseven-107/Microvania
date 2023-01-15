extends KinematicBody2D

onready var sprite = $AnimatedSprite

onready var vis = $VisibilityNotifier2D
onready var damage_zone = $Damage_zone

onready var timer = $Respawn_timer


export (int) var hp: int = 1
export (int) var team: int = 1

export (float) var speed: float = 10

var velocity: Vector2
var move: Vector2
var rotating: int

var active: bool = false



# Set up
func _ready():
	damage_zone.team = self.team

	set_physics_process(active)
	damage_zone.set_process(active)

	vis.connect("screen_entered", self, "enable_disable")
	vis.connect("screen_exited", self, "enable_disable")



# Movement
func _physics_process(delta):
	if timer.is_stopped():
		sprite.playing = true

		if rotating:
			rotation = lerp_angle(rotation, velocity.angle(), 0.5)
			rotating -= 1

			return

		var collision = move_and_collide(move * speed * delta)
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
	if timer.is_stopped():
		hp -= damage

		#fx_anims.play("Hit")

		if hp <= 0:
			die()


func die():
	damage_zone.active = false
	timer.start()
	hide()



# Enable disable functions
func enable_disable():
	if !active:
		active = true

		if timer.is_stopped():
			damage_zone.active = true
			show()

	else:
		active = false
	set_physics_process(active)
	damage_zone.set_process(active)





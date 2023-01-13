extends KinematicBody2D


onready var vis = $VisibilityNotifier2D


export (int) var hp: int = 1
export (int) var damage: int = 1
export (int) var team: int = 1

export (float) var speed: float = 10

var velocity: Vector2
var move: Vector2
var rotating: int

var active: bool = false



# Set up
func _ready():
	vis.connect("screen_entered", self, "enable_disable")
	vis.connect("screen_exited", self, "enable_disable")



# Movement
func _physics_process(delta):
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



# Damage
func _on_Damage_zone_body_entered(body: Node):
	if body.has_method("handle_hit") and body.team != team:
		body.handle_hit(damage)
	



# Enable disable functions
func enable_disable():
	if !active:
		active = true
	else:
		active = false
	set_physics_process(active)




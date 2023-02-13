extends Node2D
class_name Crawler_Enemy


onready var parent = get_parent()

# Movement Variables
export (float) var max_speed: float = 10

var velocity: Vector2
var move: Vector2
var rotating: int



# Movement
func loop(delta):
	if rotating:
		rotation = lerp_angle(rotation, velocity.angle(), 0.5)
		rotating -= 1

		return

	var collision = parent.move_and_collide(move * max_speed * delta)
	if collision and collision.normal.rotated(PI/2).dot(move) < 0.5:
		rotating = 4
		move = collision.normal.rotated(PI/2)

		return

	var pos = global_position
	collision = parent.move_and_collide(move.rotated(PI/2) * 15)

	if not collision:
		for i in 10:
			global_position = pos
			rotate(PI/32)

			move = move.rotated(PI/32)
			collision = parent.move_and_collide(move.rotated(PI/2) * 15)

			if collision:
				move = collision.normal.rotated(PI/2)
				rotation = move.angle()

				break

	else:
		move = collision.normal.rotated(PI/2)
		rotation = move.angle()
		# Place the enemy at the edge of a platue one and make the collider contact the surface.

	parent.global_position = global_position
	parent.rotation = rotation



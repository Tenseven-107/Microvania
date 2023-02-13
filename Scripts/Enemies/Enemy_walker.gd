extends Node2D
class_name Walker_Enemy


onready var parent = get_parent()
onready var raycast = $RayCast2D

# Movement Variables
export (float) var max_speed: float = 10
var speed: float = 10

var pos_x: float
var ray_pos_x: float

var velocity: Vector2


# Set up
func _ready():
	pos_x = parent.position.x
	ray_pos_x = raycast.position.x
	if raycast.position.x < 0:
		ray_pos_x = -raycast.position.x



# Movement
func loop(_delta):
	velocity.x = speed
	if !raycast.is_colliding() or parent.is_on_wall():
		if parent.position.x < pos_x:
			speed = max_speed

			if parent.flip_sprite:
				parent.sprite.flip_h = true

			raycast.position.x = ray_pos_x
		elif parent.position.x > pos_x:
			speed = -max_speed

			if parent.flip_sprite:
				parent.sprite.flip_h = false

			raycast.position.x = -ray_pos_x

	velocity = parent.move_and_slide(velocity, Vector2.UP)

		# Place the enemy on the ground




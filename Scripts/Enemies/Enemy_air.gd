extends Node2D
class_name Air_Enemy


onready var parent = get_parent()

# Movement Variables
export (float) var max_speed: float = 10
var speed: float = 10
var velocity: Vector2
onready var pos_x: float



# Set up
func _ready():
	pos_x = parent.position.x



# Movement
func loop(_delta):
	velocity.x = speed
	if parent.is_on_wall():
		if parent.position.x < pos_x:
			speed = max_speed
		elif parent.position.x > pos_x:
			speed = -max_speed

	velocity = parent.move_and_slide(velocity)

		# Place the enemy in the air





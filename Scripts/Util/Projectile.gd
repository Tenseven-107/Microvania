extends Area2D
class_name Projectile


onready var collider = $CollisionShape2D
onready var vis = $VisibilityNotifier2D


# Movement
export (int) var speed = 225


# Damage
export (int) var damage: int = 1
export (int) var team: int = 1

export (bool) var can_damage: bool = true

# Juice
export (bool) var juice: bool = false
export (float, 0, 10) var screenshake: float = 1
export (float, 0, 1) var hitstop_time: float = 0.1


# Set up
func _ready():
	vis.connect("screen_exited", self, "queue_free")



# Damage
func _on_Projectile_body_entered(body: Node):
	if body.has_method("handle_hit") and body.team != team and !body.dead:
		body.handle_hit(damage, true)

		if juice:
			GlobalSignals.emit_signal("screenshake", screenshake, 0.05)
			GlobalSignals.emit_signal("hitstop", hitstop_time)

	if !body.has_method("handle_hit"):
		call_deferred("queue_free")



# Movement
func _physics_process(delta):
	position += transform.x * speed * delta



# Misc
func _process(delta):
	collider.disabled = get_can_damage()



# Getting if the area can damage
func get_can_damage():
	var d: bool = true
	if can_damage:
		d = false
	else:
		d = true

	return d




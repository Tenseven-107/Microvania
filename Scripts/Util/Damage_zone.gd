extends Area2D
class_name DamageZone


onready var collider = $CollisionShape2D

# Damage
export (int) var damage: int = 1
export (int) var team: int = 1

export (bool) var constant: bool = false
export (bool) var can_damage: bool = true

# Juice
export (bool) var juice: bool = false
export (float, 0, 10) var screenshake: float = 1
export (float, 0, 1) var hitstop_time: float = 0.1



# Damage
func _on_Damage_zone_body_entered(body: Node):
	if body.has_method("handle_hit") and body.team != team and !body.dead:
		body.handle_hit(damage)

		if juice:
			GlobalSignals.emit_signal("screenshake", screenshake, 0.05)
			GlobalSignals.emit_signal("hitstop", hitstop_time)



func _process(delta):
	if constant:
		for body in get_overlapping_bodies():
			if body.has_method("handle_hit") and body.team != team and !body.dead:
				body.handle_hit(damage)

	collider.disabled = get_can_damage()



# Getting if the area can damage
func get_can_damage():
	var d: bool = true
	if can_damage:
		d = false
	else:
		d = true

	return d





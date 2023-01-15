extends Area2D
class_name DamageZone


onready var collider = $CollisionShape2D


export (int) var damage: int = 1
export (int) var team: int = 1

export (bool) var constant: bool = false
export (bool) var can_damage: bool = true



# Damage
func _on_Damage_zone_body_entered(body: Node):
	if body.has_method("handle_hit") and body.team != team:
		body.handle_hit(damage)



func _process(delta):
	if constant:
		for body in get_overlapping_bodies():
			if body.has_method("handle_hit") and body.team != team:
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





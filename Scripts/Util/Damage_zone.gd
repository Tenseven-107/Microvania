extends Area2D


export (int) var damage: int = 1
export (int) var team: int = 1

# Damage
func _on_Damage_zone_body_entered(body: Node):
	if body.has_method("handle_hit") and body.team != team:
		body.handle_hit(damage)

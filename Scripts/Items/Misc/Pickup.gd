extends Area2D


onready var anims = $AnimationPlayer
onready var vis = $VisibilityNotifier2D

export (int) var plus_hp: int = 1
export (int) var plus_power: int = 1

export (bool) var can_heal: bool = false
export (bool) var can_recharge: bool = false

var can_pickup: bool = true



# Set up
func _ready():
	can_pickup = true
	anims.play("Float")

	vis.connect("screen_exited", self, "queue_free")



# When picked up
func heal(body):
	if body.hp < body.max_hp:
		body.handle_hit(plus_hp, false)

	elif body.hp >= body.max_hp:
		can_pickup = false


func recharge(body):
	body.power += plus_power



func _on_Pickup_body_entered(body: Player):
	if body and body.has_method("handle_hit"):
		if can_heal:
			heal(body)

		if can_recharge and can_pickup:
			recharge(body)

		if can_pickup:
			call_deferred("queue_free")




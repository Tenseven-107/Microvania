extends Area2D
class_name Projectile



export (PackedScene) var impact: PackedScene = preload("res://Prefabs/FX/Projectile_impact.tscn")


onready var collider = $CollisionShape2D
onready var vis = $VisibilityNotifier2D


# Movement
export (int) var speed: int = 225

export (bool) var normal_projectile: bool = true

	# Gravitational throwable
export (float) var throw_velocity: float = 150
export (int) var gravity_pull: int = 98
var velocity: Vector2


# Damage
export (int) var damage: int = 1
export (int) var team: int = 1

export (bool) var can_damage: bool = true

# Juice
export (bool) var animations: bool = false
export (bool) var juice: bool = false
export (float, 0, 10) var screenshake: float = 1
export (float, 0, 1) var hitstop_time: float = 0.1


# Set up
func _ready():
	gravity = gravity_pull
	velocity = transform.x * throw_velocity

	if animations:
		var anims = get_node("AnimationPlayer") # Add an anim player and enable animations to add anims
		anims.play("default") # Name your anim default

	vis.connect("screen_exited", self, "queue_free")



# Damage
func _on_Projectile_body_entered(body: Node):
	if body.has_method("handle_hit") and body.team != team and !body.dead:
		body.handle_hit(damage, true)

		if juice:
			GlobalSignals.emit_signal("screenshake", screenshake, 0.05)
			GlobalSignals.emit_signal("hitstop", hitstop_time)

	if !body.has_method("handle_hit") or body.team != team:
		if body is TileMap:
			var instance = impact.instance()
			var parent = get_parent()

			instance.global_position = global_position
			parent.call_deferred("add_child", instance)

		call_deferred("queue_free")



# Movement
func _physics_process(delta):
	if normal_projectile:
		position += transform.x * speed * delta

	else:
		velocity.y += gravity * delta
		position += velocity * delta



# Misc
func _process(_delta):
	collider.disabled = get_can_damage()



# Getting if the area can damage
func get_can_damage():
	var d: bool = true
	if can_damage:
		d = false
	else:
		d = true

	return d




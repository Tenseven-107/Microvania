extends KinematicBody2D
class_name Enemy_Entity


onready var ai = $AI

onready var sprite = $AnimatedSprite

onready var collider = $CollisionShape2D

onready var vis = $VisibilityNotifier2D
onready var damage_zone = $Damage_zone

onready var respawn_timer = $Respawn_timer

onready var anims = $Anims
onready var appear_sfx = $SFX/RandomAudioStreamPlayer2D3

var fx_container = null


# Fx
export (PackedScene) var dead_fx: PackedScene


# Combat variables
export (int) var max_hp: int = 2
var hp: int = 2
export (int) var team: int = 1

# Checks
export (bool) var flip_sprite: bool = true

var active: bool = false
var dead: bool = false



# Set up
func _ready():
	damage_zone.team = self.team

	hp = max_hp

	set_physics_process(active)
	damage_zone.set_process(active)

	vis.connect("screen_entered", self, "enable_disable")
	vis.connect("screen_exited", self, "enable_disable")



# Movement
func _physics_process(delta):
	if respawn_timer.is_stopped() and !dead:
		sprite.playing = true
		ai.loop(delta)



# Taking damage
func handle_hit(damage, _null_value):
	if respawn_timer.is_stopped() and !dead:
		hp -= damage

		anims.play("Hit")

		if hp <= 0:
			die()


func die():
	respawn_timer.start()
	dead = true

	damage_zone.can_damage = false
	collider.set_deferred("disabled", true)

	GlobalSignals.emit_signal("spawn_item", global_position)

	var dead_inst =  dead_fx.instance()
	dead_inst.global_position = global_position
	fx_container.call_deferred("add_child", dead_inst)
	anims.play("Dead")

	hide()



# Enable disable functions
func enable_disable():
	if !active:
		active = true

		appear_sfx.play()

		# Respawn Enemy
		if respawn_timer.is_stopped() and dead:
			hp = max_hp
			dead = false

			damage_zone.can_damage = true
			collider.set_deferred("disabled", false)

			anims.play("RESET")
			show()

	else:
		active = false

		# If still dead, dont respawn
		if !respawn_timer.is_stopped() and dead:
			respawn_timer.start()
			dead = true

			damage_zone.can_damage = false
			collider.set_deferred("disabled", true)

			hide()

	set_physics_process(active)
	damage_zone.set_process(active)



# Initialization
func initialize(fx_cont):
	self.fx_container = fx_cont

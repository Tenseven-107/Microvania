extends KinematicBody2D
class_name Player



# Fx
export (PackedScene) var dust_puff: PackedScene

# Componnents
onready var raycasts = $Raycasts

onready var coyote = $Coyote_time
onready var i_frames = $I_frames
onready var cooldown = $Whip_cooldown

onready var sprite = $AnimatedSprite
onready var anims = $AnimationTree

onready var weapon = $Weapon
onready var damage_zone = $Weapon/Damage_zone

onready var fx_anims = $FX_anims
onready var dust_pos = $FX/Dust_pos
onready var trail = $AnimatedSprite/SpriteTrail
onready var move_dust = $FX/CPUParticles2D


var anim_state_machine: AnimationNodeStateMachinePlayback

# Movement stats
export (float) var gravity: float = 100
export (float) var max_fall_speed: float = 300
export (float) var speed: float  = 50
export (float) var acceleration: float  = 55
export (float) var jump_force: float  = 420

var motion = Vector2()

# Stats
export (int) var hp: int = 3
export (int) var team: int = 0
export (bool) var dead: bool = false

# Move checks
export (bool) var locked: bool = false
var can_jump: bool = true

# Misc
var camera = null
var fx_container = null


# Set up
func _ready():
	anims.active = true
	trail.active = false

	damage_zone.team = self.team

	anim_state_machine = anims.get("parameters/playback")


# Process
func _physics_process(delta):
	# Gravity
	motion.y += gravity
	if motion.y > max_fall_speed:
		motion.y  = max_fall_speed

	if !is_on_floor():
		anim_state_machine.travel("Fall")

		trail.active = false
		if move_dust.emitting:
			move_dust.emitting = false
	else:
		anim_state_machine.start("Land")

	motion.x = clamp(motion.x, -speed, speed)


	# Movement
	if !locked:
		if Input.is_action_pressed("right"):
			motion.x += acceleration
			weapon.scale.x = 1

			sprite.flip_h = false
		elif Input.is_action_pressed("left"):
			motion.x -= acceleration
			weapon.scale.x = -1

			sprite.flip_h = true
		else: 
			motion.x = move_toward(motion.x, 0, delta * (speed * 4))

	else:
		motion.x = 0

	if motion.x != 0 and is_on_floor():
		anim_state_machine.travel("Walk")

		if (motion.x == (speed + acceleration) 
		or motion.x == -(speed + acceleration)):
			move_dust.emitting = true
		else:
			move_dust.emitting = false

	elif motion.x == 0 and is_on_floor():
		anim_state_machine.travel("Idle")
		move_dust.emitting = false


	# Jumping
	var buffer_raycasts = raycasts.get_children()
	for br in buffer_raycasts:
		if br.is_colliding() or is_on_floor():
			coyote.start()
			can_jump = true
		else:
			can_jump = false

	if (Input.is_action_just_pressed("up") and can_jump 
	or Input.is_action_just_pressed("up") and !coyote.is_stopped()):
		motion.y = -jump_force
		can_jump = false
		coyote.stop()

		var dust_inst =  dust_puff.instance()
		dust_inst.global_position = dust_pos.global_position
		fx_container.call_deferred("add_child", dust_inst)

		anim_state_machine.start("Jump")
		trail.active = true

	if Input.is_action_just_released("up") && motion.y != 0:
		motion.y = 0


	# Ducking
	if Input.is_action_pressed("down") and !is_on_floor():
		motion.y = max_fall_speed * 4


	# Attacking
	if Input.is_action_just_pressed("attack") and cooldown.is_stopped():
		anim_state_machine.start("Attack")
		cooldown.start()


	# Motion
	motion = move_and_slide(motion, Vector2.UP)



# Taking damage
func handle_hit(damage):
	if i_frames.is_stopped():
		i_frames.start()
		hp -= damage

		fx_anims.play("Hit")
		GlobalSignals.emit_signal("screenshake", 5, 0.1)
		GlobalSignals.emit_signal("hitstop", 0.5)

		if hp <= 0:
			die()
	print("player hit")


func die():
	dead = true
	queue_free()



# Initialization
func initialize(fx_cont):
	self.fx_container = fx_cont




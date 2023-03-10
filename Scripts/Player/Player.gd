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

onready var throwable_controller = $Throwable

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
export (int) var max_hp: int = 3
export (int) var team: int = 0

export (int) var power: int = 0

# Move checks
enum {
	ACTIVE,
	ATTACKING,
	CAN_JUMP,
	DEAD
}
var state = null
var can_jump: bool = true

# Misc
var camera = null
var fx_container = null


# Set up
func _ready():
	anims.active = true
	trail.active = false

	damage_zone.team = self.team
	throwable_controller.team = self.team
	hp = max_hp

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
	elif state != ATTACKING:
		anim_state_machine.start("Land")

	motion.x = clamp(motion.x, -speed, speed)


	# State Machine
	match state:

		ACTIVE:

			# Movement
			if Input.is_action_pressed("right"):
				motion.x += acceleration
				weapon.scale.x = 1
				throwable_controller.scale.x = 1

				sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				motion.x -= acceleration
				weapon.scale.x = -1
				throwable_controller.scale.x = -1

				sprite.flip_h = true
			else: 
				motion.x = move_toward(motion.x, 0, delta * (speed * 4))

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

		ATTACKING:
			motion.x = 0

		DEAD:
			pass

	# Down
	if Input.is_action_pressed("down") and !is_on_floor():
		motion.y = max_fall_speed * 4

	# Attacking
	if Input.is_action_just_pressed("attack") and cooldown.is_stopped():
		anim_state_machine.start("Attack")
		set_state(ATTACKING)

		cooldown.start()
	elif cooldown.is_stopped():
		set_state(ACTIVE)

	if (Input.is_action_just_pressed("action") and throwable_controller.get_handler() 
	and throwable_controller.get_handler_stopped() and power > 0):
		throwable_controller.handle_attack()
		set_state(ATTACKING)

		anim_state_machine.start("Throw")
	elif throwable_controller.get_handler_stopped():
		set_state(ACTIVE)


	# Motion
	motion = move_and_slide(motion, Vector2.UP)



# Switch state
func set_state(new_state):
	if new_state != null:
		state = new_state
	elif new_state == null:
		state = ACTIVE



# Taking damage
func handle_hit(value, damaging: bool):
	if i_frames.is_stopped() and damaging and state != DEAD:
		i_frames.start()
		hp -= value

		fx_anims.play("Hit")
		GlobalSignals.emit_signal("screenshake", 5, 0.1)
		GlobalSignals.emit_signal("hitstop", 0.5)

		if hp <= 0:
			die()

	elif !damaging:
		hp += value
		hp = int(clamp(hp, 0, max_hp))
		fx_anims.play("Heal")


func die():
	set_state(DEAD)
	queue_free()



# Getting the throwable controller
func get_throwable_controller():
	return throwable_controller



# Initialization
func initialize(fx_cont, pro_cont):
	self.fx_container = fx_cont
	throwable_controller.initialize(pro_cont)




extends Node2D


onready var particles = $CPUParticles2D
onready var timer = $Timer


# start fx
func _ready():
	particles.emitting = true
	timer.start()

# End fx
func _on_Timer_timeout():
	queue_free()

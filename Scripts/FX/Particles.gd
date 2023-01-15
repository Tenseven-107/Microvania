extends Node2D

onready var particles = $Particles
onready var timer = $Timer


# start fx
func _ready():
	var effects = particles.get_children()
	for effect in effects:
		effect.emitting = true

	timer.start()

# End fx
func _on_Timer_timeout():
	queue_free()

extends Node2D

onready var particles = $Particles
onready var timer = $Timer

export (bool) var sounds: bool = false


# start fx
func _ready():
	var effects = particles.get_children()
	for effect in effects:
		effect.emitting = true

	if sounds:
		var sound = get_node("Audio") # name stream player "Audio"
		sound.play()

	timer.start()

# End fx
func _on_Timer_timeout():
	queue_free()

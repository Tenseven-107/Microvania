extends Area2D
class_name ThrowablePickup


onready var anims = $AnimationPlayer

export (PackedScene) var throwable: PackedScene



# When player picks up object
func _on_Throwable_knife_body_entered(body: Player):
	if body:
		var throwable_controller = body.get_throwable_controller()
		throwable_controller.update_controller(throwable)
		anims.play("Collected")



# Delete
func _on_AnimationPlayer_animation_finished(anim_name = "Collected"):
	queue_free()

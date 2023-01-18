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



# When the upgrade gets back in the screen
func _on_VisibilityNotifier2D_screen_entered():
	anims.play("RESET")

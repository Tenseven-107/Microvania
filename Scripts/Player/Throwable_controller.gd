extends Node2D
class_name ThrowableController


var children: Array
var child_count: int

var projectile_container = null
var handler = null

var team: int = 0


# Updates the children
func update_controller(throwable):
	var instance = throwable.instance()
	instance.initialize(projectile_container)

	handler = instance
	instance.team = self.team
	self.add_child(instance)

	child_count = self.get_child_count()
	children = self.get_children()

	if child_count > 1:
		children.pop_front().queue_free()



# Handles attacks
func handle_attack():
	var power = get_parent().power
	if is_instance_valid(handler) and power > 0:
		handler.attack()

		get_parent().power -= 1
		if power <= 0:
			power = 0



# Getters
func get_handler():
	return handler

func get_handler_stopped():
	if is_instance_valid(handler):
		return handler.get_if_stopped()



# Initialization
func initialize(pro_cont):
	self.projectile_container = pro_cont





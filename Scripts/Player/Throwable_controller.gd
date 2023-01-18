extends Node2D
class_name ThrowableController


var children: Array
var child_count: int

var projectile_container = null
var handler = null


# Updates the children
func update_controller(throwable):
	var instance = throwable.instance()
	instance.initialize(projectile_container)

	handler = instance
	self.add_child(instance)

	child_count = self.get_child_count()
	children = self.get_children()

	if child_count > 1:
		children.pop_front().queue_free()



# Handles attacks
func handle_attack():
	if is_instance_valid(handler):
		handler.attack()



# Get handler
func get_handler():
	return handler



# Initialization
func initialize(pro_cont):
	self.projectile_container = pro_cont





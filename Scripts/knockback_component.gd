class_name KnockbackComponent
extends Node

@export var knockback_force: float = 1.0
@export var knockback_box: Area2D

func knockback():
	if not knockback_box:
		push_error("KnockbackComponent: No Area2D assigned!")
		return
		
	# Get all physics bodies currently inside the Area2D
	var bodies = knockback_box.get_overlapping_bodies()
	print(bodies)
	# Get the global position of the source to calculate the push direction
	var source_position = knockback_box.global_position
	
	for body in bodies:
		if body == get_parent():
			continue
			
		# Calculate direction and velocity
		var direction = (body.global_position - source_position).normalized()
		if direction == Vector2.ZERO:
			direction = Vector2.UP 
		var knockback_velocity = direction * knockback_force

		# OPTION A: Check if the body natively has the function
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback_velocity)
			
		# OPTION B: Check if the body has our new Receiver Component via metadata
		elif body.has_meta("KnockbackReceiver"):
			var receiver = body.get_meta("KnockbackReceiver")
			receiver.receive_knockback(knockback_velocity)
			

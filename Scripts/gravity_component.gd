class_name GravityComponent
extends Node

@export var gravity_multiplier: float = 0.8
@export var body: Node
@export var jump_released_multiplier: float = 2.3

var wants_jump: bool = false

func update(delta):
	# Sets gravity based on multiplier
	if not body.is_on_floor():
		var current_gravity = body.get_gravity() * gravity_multiplier
	
	# Weakens gravity if jump is pressed in the air
		if not wants_jump:
			current_gravity *= jump_released_multiplier
	
	# Applies gravity
		body.velocity += current_gravity * delta

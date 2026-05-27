class_name GravityComponent
extends Node

@onready var velocity_component: VelocityComponent = $"../VelocityComponent"

@export var gravity_multiplier: float = 1.0
@export var body: Node2D
@export var jump_released_multiplier: float = 1.0
@export var base_gravity: float = 980.0 

var wants_jump: bool = false

func update(delta: float) -> void:
	if body == null:
		return

	# HANDLE CHARACTERBODY2D
	if body is CharacterBody2D:
		if not body.is_on_floor():
			var current_gravity = body.get_gravity() * gravity_multiplier
			if not wants_jump:
				current_gravity *= jump_released_multiplier
			body.velocity += current_gravity * delta

	# HANDLE NODE2D
	elif body is Node2D:
		
		var gravity_vector = Vector2.DOWN * base_gravity
		var current_gravity = gravity_vector * gravity_multiplier
		
		if not wants_jump:
			current_gravity *= jump_released_multiplier
			
		# If finds a velocity component, pushes gravity into its Y axis
		if velocity_component:
			velocity_component.velocity.y += current_gravity.y * delta

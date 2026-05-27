class_name VelocityComponent
extends Node

@export var body: Node2D
@export var speed: float = 200.0

var previous_speed: float = 0.0
var current_speed: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var direction: float = 0.0

func update(delta: float) -> void:
	if body == null:
		push_error("NULL VELOCITY COMPONENT BODY")
		return

	if body.has_method("move_and_slide"):
		previous_speed = abs(body.velocity.x)
		body.velocity.x = lerp(body.velocity.x, direction * speed, 10.0 * delta)
		current_speed = abs(body.velocity.x)
		body.move_and_slide()
		
	elif body is Node2D:
		# Apply the horizontal direction and speed to our velocity vector
		velocity.x = direction * speed
		
		# Move the body using the unified velocity vector
		body.position += velocity * delta
		#print(velocity)
		print(body.position)

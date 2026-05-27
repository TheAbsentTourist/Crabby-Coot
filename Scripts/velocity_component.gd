class_name VelocityComponent
extends Node

@onready var knockback_recieving_component: KnockbackReceiverComponent = $"../KnockbackRecievingComponent"

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

	# 1. Fetch the active knockback velocity if the component exists
	var knockback = Vector2.ZERO
	if knockback_recieving_component:
		knockback = knockback_recieving_component.knockback_velocity

	if body.has_method("move_and_slide"):
		previous_speed = abs(body.velocity.x)
		
		# Calculate your desired baseline walk velocity
		var target_walk_x = lerp(body.velocity.x, direction * speed, 10.0 * delta)
		
		# 2. COMBINE: Set character's velocity as standard movement PLUS knockback
		# (We include knockback.y here too, just in case your knockback pushes vertically!)
		body.velocity.x = target_walk_x + knockback.x
		body.velocity.y = knockback.y 
		
		current_speed = abs(body.velocity.x)
		body.move_and_slide()
		
	elif body is Node2D:
		# Apply the horizontal direction and speed to our baseline velocity vector
		velocity.x = direction * speed
		
		# 3. COMBINE: Add knockback to the basic translation movement
		var final_velocity = velocity + knockback
		
		# Move the body using the unified final velocity vector
		body.position += final_velocity * delta

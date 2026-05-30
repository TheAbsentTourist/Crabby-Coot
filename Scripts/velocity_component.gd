class_name VelocityComponent
extends Node

@export var knockback_recieving_component: Node

@export var body: Node2D
@export var speed: float = 200.0

# Replaced single 'friction' with separate acceleration and deceleration fields
@export var acceleration: float = 10.0
@export var deceleration: float = 12.0

var previous_speed: float = 0.0
var current_speed: float = 0.0
var velocity: Vector2 = Vector2.ZERO

# --- COMPATIBILITY LAYER ---
var direction: float = 0.0:
	set(value):
		direction = value
		direction_v2 = Vector2(value, 0.0)

var direction_v2: Vector2 = Vector2.ZERO
# ---------------------------

func update(delta: float) -> void:
	if body == null:
		push_error("NULL VELOCITY COMPONENT BODY")
		return

	var knockback = Vector2.ZERO
	if knockback_recieving_component:
		knockback = knockback_recieving_component.knockback_velocity

	if body.has_method("move_and_slide"):
		previous_speed = body.velocity.length()
		
		if direction_v2 != Vector2.ZERO and direction == 0.0:
			var clean_dir = direction_v2.normalized()
			# Vector2 movement always uses acceleration here since direction_v2 is not zero
			body.velocity = body.velocity.lerp(clean_dir * speed, acceleration * delta)
			body.velocity += knockback
		else:
			# Determine whether to use acceleration or deceleration based on manual input
			var active_weight = acceleration if direction != 0.0 else deceleration
			
			var target_walk_x = lerp(body.velocity.x, direction * speed, active_weight * delta)
			body.velocity.x = target_walk_x + knockback.x
			body.velocity.y += knockback.y
			
		current_speed = body.velocity.length()
		body.move_and_slide()
		
	elif body is Node2D:
		if direction_v2 != Vector2.ZERO and direction == 0.0:
			velocity = direction_v2.normalized() * speed
		else:
			velocity = Vector2(direction * speed, 0.0)
		
		var final_velocity = velocity + knockback
		
		body.position += final_velocity * delta

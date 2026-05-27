class_name VelocityComponent
extends Node

@export var knockback_recieving_component: Node

@export var body: Node2D
@export var speed: float = 200.0

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
			# FIX 1: Force normalization here to protect move_and_slide velocity values
			var clean_dir = direction_v2.normalized()
			body.velocity = body.velocity.lerp(clean_dir * speed, 10.0 * delta)
			body.velocity += knockback
		else:
			var target_walk_x = lerp(body.velocity.x, direction * speed, 10.0 * delta)
			body.velocity.x = target_walk_x + knockback.x
			body.velocity.y += knockback.y
			
		
		current_speed = body.velocity.length()
		body.move_and_slide()
		
	elif body is Node2D:
		if direction_v2 != Vector2.ZERO and direction == 0.0:
			# FIX 2: Force normalization here to protect basic Node2D translation values
			velocity = direction_v2.normalized() * speed
		else:
			velocity = Vector2(direction * speed, 0.0)
		
		var final_velocity = velocity + knockback
		
		
		body.position += final_velocity * delta

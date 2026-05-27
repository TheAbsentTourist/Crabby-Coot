class_name VelocityComponent
extends Node

@export var body: Node
@export var speed: float = 200.0

@onready var flip_component: FlipComponent = $"../FlipComponent"

var previous_speed: float = 0.0
var current_speed: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var direction: float = 0.0

func update(delta: float) -> void:
	if body.has_method("move_and_slide"):
		previous_speed = abs(body.velocity.x)
		body.velocity.x = lerp(body.velocity.x, direction * speed, 10.0 * delta)
		current_speed = abs(body.velocity.x)
		body.move_and_slide()
	elif body is Node2D:
		# If it's a simple projectile, just move its position directly horizontally
		body.position.x += direction * speed * delta
	

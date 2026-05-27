class_name FlipComponent
extends Node

@export var sprite: Node2D
@export var flip_collisions: bool = false
@export var right_collision: CollisionPolygon2D
@export var left_collision: CollisionPolygon2D
@onready var velocity_component: VelocityComponent = $"../VelocityComponent"



func update(direction: float) -> void:
	if velocity_component.direction < 0:
		sprite.flip_h = true
		if flip_collisions:
			right_collision.disabled = false
			left_collision.disabled = true
			#right_collision.visible = false
			#left_collision.visible = true
	elif velocity_component.direction > 0:
		sprite.flip_h = false
		if flip_collisions:
			right_collision.disabled = true
			left_collision.disabled = false
			#right_collision.visible = true
			#left_collision.visible = false

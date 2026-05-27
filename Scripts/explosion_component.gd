class_name ExplosionComponent
extends Node

@onready var velocity_component: VelocityComponent = $"../VelocityComponent"

@export var explode_box: Area2D
@export var knockback_box: Area2D
@export var animation_sprite: AnimatedSprite2D
@export var knockback_force: float = 500.0

var projectile_direction: float = 0.0

func _ready() -> void:
	# Warnings & Connections
	if explode_box:
		# Detects other Area2Ds
		explode_box.area_entered.connect(_on_explode_box_area_entered)
		# Detects solid PhysicsBodies (walls, enemies, players, etc.)
		explode_box.body_entered.connect(_on_explode_box_body_entered)
	else:
		push_warning("No explode box assigned in explosion component")
	
	if animation_sprite:
		animation_sprite.play("fireball")
	else:
		push_warning("No animation sprite assigned in explosion component")

func explode() -> void:
	
	if knockback_box:
		for body in knockback_box.get_overlapping_bodies():
			var dir = (body.global_position - get_parent().global_position).normalized()
			if body is RigidBody2D:
				body.apply_central_impulse(dir * knockback_force)
			elif "velocity" in body: # Catches CharacterBody2D & anything with velocity
				body.velocity += dir * knockback_force
	
	# Disable collisions immediately so it doesn't trigger multiple times
	if explode_box:
		explode_box.set_deferred("monitoring", false)
	
	if animation_sprite:
		get_parent().set_physics_process(false)
		animation_sprite.play("explode")
		# Wait for the explosion animation to finish before destroying the node
		await animation_sprite.animation_finished
		
	get_parent().queue_free()

# Triggered by other Area2Ds
func _on_explode_box_area_entered(_other_area: Area2D) -> void:
	explode()

# Triggered by solid bodies (Tilemaps, CharacterBody2D, StaticBody2D, etc.)
func _on_explode_box_body_entered(_other_body: Node2D) -> void:
	explode()

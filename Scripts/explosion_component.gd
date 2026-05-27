class_name ExplosionComponent
extends Node

@export var explode_box: Area2D
@export var animation_sprite: AnimatedSprite2D

var projectile_direction: float = 0.0

func _ready() -> void:
	
	# Warnings
	if explode_box:
		explode_box.area_entered.connect(_on_explode_box_area_entered)
	else:
		push_warning("No explode box assigned in explosion component")
	
	animation_sprite.play("fireball")
	
	# Rotates in movement direction

func explode():
	animation_sprite.play("explode")
	queue_free()

func _on_explode_box_area_entered(other_area: Area2D) -> void:
	pass

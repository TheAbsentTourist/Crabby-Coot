class_name KnockbackReceiverComponent
extends Node


@export var character_body: CharacterBody2D
@export var deceleration: float = 500.0

var knockback_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not character_body and get_parent() is CharacterBody2D:
		character_body = get_parent()
		
	if character_body:
		character_body.set_meta("KnockbackReceiver", self)

func _physics_process(delta: float) -> void:
	# Just decay the force over time
	if knockback_velocity != Vector2.ZERO:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, deceleration * delta)

func receive_knockback(velocity: Vector2) -> void:
	knockback_velocity = velocity

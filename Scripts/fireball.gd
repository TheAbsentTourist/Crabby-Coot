class_name Fireball
extends Node2D

@onready var explosion_component: ExplosionComponent = $ExplosionComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var movement_component: MovementComponent = $MovementComponent

@export var speed: float = 10

var explosion_called: bool = false

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

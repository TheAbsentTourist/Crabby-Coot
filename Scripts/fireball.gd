class_name Fireball
extends Node2D

@onready var explosion_component: ExplosionComponent = $ExplosionComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var gravity_component: GravityComponent = $GravityComponent


@export var speed: float = 10

var explosion_called: bool = false

func _ready() -> void:
	velocity_component.direction = 1.0

func _physics_process(delta: float) -> void:
	
	# Ticks Velocity Component
	velocity_component.update(delta)
	
	# Ticks Gravity Compoent
	gravity_component.update(delta)
	

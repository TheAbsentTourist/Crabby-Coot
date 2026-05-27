class_name Fireball
extends Node2D

@onready var explosion_component: ExplosionComponent = $ExplosionComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var gravity_component: GravityComponent = $GravityComponent

@export var speed: float = 600.0 

# Store the direction locally so it isn't lost
var current_direction: Vector2 = Vector2.RIGHT

# 1. This runs the MOMENT the spawner creates the fireball
func set_direction(new_dir: Vector2) -> void:
	current_direction = new_dir.normalized() 
	rotation = current_direction.angle()     

# 2. This runs right AFTER the fireball and its components enter the scene tree
func _ready() -> void:
	if velocity_component:
		velocity_component.speed = speed 
		velocity_component.direction_v2 = current_direction

func _physics_process(delta: float) -> void:
	velocity_component.update(delta)
	if gravity_component:
		gravity_component.update(delta)

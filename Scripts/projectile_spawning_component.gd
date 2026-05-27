class_name ProjectileSpawningComponent
extends Node

@export var projectile_scene: PackedScene
@export var spawn_point: Node2D
@export var cooldown_time: float = 1

var cooldown_timer: Timer

func _ready() -> void:
	# Create, configure, and add the Timer dynamically
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true # So it doesn't automatically loop
	add_child(cooldown_timer)

# This will be updated by the Player master script
func handle_shooting(is_shoot_wanted: bool, look_dir: Vector2) -> void:
	# Only shoot if the player wants to AND the timer isn't currently running
	if is_shoot_wanted and cooldown_timer.is_stopped():
		spawn_projectile(spawn_point.global_position, look_dir)
		cooldown_timer.start() # Start the cooldown clock

func spawn_projectile(spawn_position: Vector2, direction: Vector2) -> void:
	if not projectile_scene:
		return
		
	var projectile = projectile_scene.instantiate()
	
	# Position and rotate the bullet based on the look_dir passed in
	projectile.global_position = spawn_position
	projectile.global_rotation = direction.angle() 
	
	if projectile.has_method("set_direction"):
		projectile.set_direction(direction)
		
	# Ignore player collision
	var player_node = get_parent() 
	if projectile is PhysicsBody2D and player_node is CollisionObject2D:
		projectile.add_collision_exception_with(player_node)
	elif projectile.has_method("set_shooter"):
		projectile.set_shooter(player_node)
	
	get_tree().current_scene.add_child(projectile)

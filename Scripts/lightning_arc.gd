extends Node2D

@onready var line_2d: Line2D = $Line2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var max_range: float = 400.0
@export var segments_per_stage: int = 6 # Quality of each half of the bolt
@export var jitter_amplitude: float = 10.0
@export var duration: float = 0.15

# How far towards the cursor the lightning shoots before bending (in pixels)
@export var forward_shoot_distance: float = 100.0 

var target_rod: Node2D = null
var shoot_direction: Vector2 = Vector2.ZERO

# This matches the method your ProjectileSpawningComponent looks for!
func set_direction(dir: Vector2) -> void:
	shoot_direction = dir.normalized()

func _ready() -> void:
	# Make sure Line2D is set to Top Level in the inspector 
	# so we can use easy global coordinates!
	line_2d.top_level = true 
	
	target_rod = _find_best_rod()
	
	if target_rod == null:
		queue_free()
		return
		
	_update_lightning_visual()
	
	if target_rod.has_method("activate_rod"):
		target_rod.activate_rod()

	await get_tree().create_timer(duration).timeout
	queue_free()

func _process(_delta: float) -> void:
	_update_lightning_visual()

# How far towards the cursor the invisible control point is pushed
@export var curve_pull_distance: float = 150.0 
@export var total_segments: int = 15 # Higher number = smoother curve backbone

func _update_lightning_visual() -> void:
	if not is_instance_valid(target_rod):
		return
		
	var start_pt = global_position
	
	# This is our invisible "magnet" control point that creates the bend
	var control_pt = start_pt + (shoot_direction * curve_pull_distance)
	
	var end_pt = target_rod.global_position
	
	# Optional: Check if a wall blocks the path from the control point area to the rod
	ray_cast_2d.global_position = control_pt
	ray_cast_2d.target_position = ray_cast_2d.to_local(end_pt)
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		end_pt = ray_cast_2d.get_collision_point()

	# Generate the smooth, jagged curve
	_create_curved_lightning(start_pt, control_pt, end_pt)

func _create_curved_lightning(start: Vector2, control: Vector2, end: Vector2) -> void:
	line_2d.clear_points()
	
	# We will loop through the line using a percentage value 't' from 0.0 to 1.0
	for i in range(total_segments + 1):
		var t = float(i) / float(total_segments)
		
		# 1. Calculate the smooth backbone point using Quadratic Bezier Interpolation
		var smooth_point = start.bezier_interpolate(control, control, end, t)
		
		# 2. Add lightning jitter (skip jitter for the exact start and end points)
		if i > 0 and i < total_segments:
			# Calculate the instantaneous direction of the curve at this point to get a clean perpendicular normal
			var next_t = float(i + 1) / float(total_segments)
			var next_smooth = start.bezier_interpolate(control, control, end, next_t)
			var current_dir = (next_smooth - smooth_point).normalized()
			var normal = Vector2(-current_dir.y, current_dir.x)
			
			var jitter = randf_range(-jitter_amplitude, jitter_amplitude)
			smooth_point += normal * jitter
			
		line_2d.add_point(smooth_point)

# Helper function to generate a jagged path between any two points
func _add_jagged_segment(start: Vector2, end: Vector2) -> void:
	var direction = (end - start).normalized()
	var normal = Vector2(-direction.y, direction.x)
	var total_dist = start.distance_to(end)
	var segment_length = total_dist / segments_per_stage
	
	# If this is the very first point of the entire Line2D, add the start point
	if line_2d.get_point_count() == 0:
		line_2d.add_point(start)
	
	for i in range(1, segments_per_stage):
		var progress_point = start + direction * (i * segment_length)
		var jitter = randf_range(-jitter_amplitude, jitter_amplitude)
		var point = progress_point + normal * jitter
		
		line_2d.add_point(point)
		
	# Add the end point of this segment
	line_2d.add_point(end)

func _find_best_rod() -> Node2D:
	var rods = get_tree().get_nodes_in_group("lightning_rods")
	var closest_rod: Node2D = null
	var closest_distance: float = max_range
	
	for rod in rods:
		if rod is Node2D:
			var dist = global_position.distance_to(rod.global_position)
			if dist < closest_distance:
				closest_distance = dist
				closest_rod = rod
				
	return closest_rod

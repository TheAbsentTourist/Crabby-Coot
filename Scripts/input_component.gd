class_name InputComponent
extends Node



var move_dir: float = 0.0
var jump_pressed: bool = false
var look_dir: Vector2 = Vector2.RIGHT # Default fallback direction
var shoot_pressed: bool = false

func update(owner_global_pos: Vector2) -> void:
	# Left and right movement
	move_dir = Input.get_axis("move_left", "move_right")
	
	# Jump
	jump_pressed = Input.is_action_pressed("jump")
	
	# Shoot
	shoot_pressed = Input.is_action_just_pressed("shoot")
	
	
	var parent = get_parent()
	
	if parent is CanvasItem:
		var mouse_pos: Vector2 = parent.get_global_mouse_position()
		# This cleanly gives you a normalized vector pointing at the mouse
		look_dir = (mouse_pos - owner_global_pos).normalized()
	
	# DEBUG
	#print(move_dir)
	#print(jump_pressed)
	

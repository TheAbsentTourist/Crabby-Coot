class_name InputComponent
extends Node



var move_dir: float = 0.0
var jump_pressed: bool = false

func update() -> void:
	# Left and right movement
	move_dir = Input.get_axis("move_left", "move_right")
	
	# Jump
	jump_pressed = Input.is_action_pressed("jump")
	
	
	
	# DEBUG
	#print(move_dir)
	#print(jump_pressed)
	

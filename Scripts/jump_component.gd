class_name JumpComponent
extends Node

@export var body: Node
@export var jump_velocity: float = -230.0

var wants_jump: bool = false


func update(delta: float) -> void:
	
		# Jump logic
		if wants_jump and body.is_on_floor():
			body.velocity.y = jump_velocity
		wants_jump = false
			
		body.move_and_slide()

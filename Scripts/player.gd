class_name Player
extends CharacterBody2D

@onready var input_component: InputComponent = $InputComponent
@onready var jump_component: JumpComponent = $JumpComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var flip_component: FlipComponent = $FlipComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var gravity_component: GravityComponent = $GravityComponent
@onready var projectile_spawning_component: ProjectileSpawningComponent = $ProjectileSpawningComponent


func _physics_process(delta: float) -> void:
	
	# Ticks input component
	input_component.update(global_position)
	
	# Set jump component
	jump_component.wants_jump = input_component.jump_pressed
	
	# Ticks jump component
	jump_component.update(delta)
	
	# Set velocity component
	velocity_component.direction = input_component.move_dir
	
	# Ticks velocity component
	velocity_component.update(delta)
	
	# Tells Gravity component if jump is pressed
	gravity_component.wants_jump = input_component.jump_pressed
	
	# Ticks gravity component
	gravity_component.update(delta)
	
	# Ticks flip component
	flip_component.update(delta)
	
	# Pass the direction vector from input into the spawning component
	input_component.update(global_position)
	
	# 2. Extract the look_dir and shooting intent
	var target_direction: Vector2 = input_component.look_dir
	var wants_to_shoot: bool = input_component.shoot_pressed
	
	# 3. Feed that data directly into the Spawner
	projectile_spawning_component.handle_shooting(wants_to_shoot, target_direction)
	
	
	var current_abs_speed: float = velocity_component.current_speed
	var prev_abs_speed: float = velocity_component.previous_speed
	
	# Communicates with AnimationComponent and ticks it
	
	# IDLE: If we are practically standing still
	if current_abs_speed < 1.0:
		animation_component.current_state = AnimationComponent.AnimState.IDLE
		
	# ACCEL: Current speed is notably HIGHER than previous speed
	elif current_abs_speed > (prev_abs_speed + 2.0):
		animation_component.current_state = AnimationComponent.AnimState.ACCEL
		
	# DECEL: Current speed is notably LOWER than previous speed
	elif current_abs_speed < (prev_abs_speed - 2.0):
		animation_component.current_state = AnimationComponent.AnimState.DECEL
		
	# WALK: Speed has stabilized or changes are too microscopic to matter
	else:
		# Only walk if we actually have forward momentum, otherwise default to idle
		if current_abs_speed > 5.0:
			animation_component.current_state = AnimationComponent.AnimState.WALK
		else:
			animation_component.current_state = AnimationComponent.AnimState.IDLE
	
	animation_component.update()

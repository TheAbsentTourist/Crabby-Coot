class_name AnimationComponent
extends Node

# Define the possible animation states
enum AnimState { IDLE, WALK, ACCEL, DECEL }

@export var AnimatedSprite: AnimatedSprite2D

# Keep custom names to change them in the inspector
@export var idle_anim_name: String = "idle"
@export var walk_anim_name: String = "walk"
@export var accel_anim_name: String = "acceleration"
@export var decel_anim_name: String = "deceleration"

# A single variable tracking the current state, defaulting to IDLE
var current_state: AnimState = AnimState.IDLE

# A helper dictionary to map the enum to the actual string names
@onready var anim_map: Dictionary = {
	AnimState.IDLE: idle_anim_name,
	AnimState.WALK: walk_anim_name,
	AnimState.ACCEL: accel_anim_name,
	AnimState.DECEL: decel_anim_name
}

# Track the previous state to detect changes
var previous_state: AnimState = AnimState.IDLE

func update() -> void:
	var anim_to_play = anim_map[current_state]
	
	# ONLY play if the state actually changed, or if it's not already playing
	if current_state != previous_state or not AnimatedSprite.is_playing():
		AnimatedSprite.play(anim_to_play)
		#print("Switched to animation: ", anim_to_play)
	
	# Update our tracker for the next frame
	previous_state = current_state

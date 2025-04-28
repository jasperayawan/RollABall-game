extends Camera3D

@export var target: Node3D
@export var follow_distance: float = 10.0
@export var height: float = 5.0
@export var follow_speed: float = 5.0

func _process(delta):
	if target:
		# Follow only the player's position, ignore rotation
		var target_position = target.global_transform.origin
		
		# Set a fixed camera offset (back and up)
		var offset = Vector3(0, height, follow_distance)
		
		var desired_position = target_position + offset
		
		# Smoothly interpolate the camera's position
		global_transform.origin = global_transform.origin.lerp(desired_position, delta * follow_speed)
		
		# Always look at the player
		look_at(target_position, Vector3.UP)

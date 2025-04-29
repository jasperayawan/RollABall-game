extends CharacterBody3D

@export var speed := 5.0  # Increased speed for smoother movement
@export var base_speed := 4.0
@export var gravity := 9.8

@export var jump_velocity := 10.0
@export var jump_gravity := 20.0
@export var fall_gravity := 30.0

@export var normal_speed := 5.0
@export var run_speed := 10.0

@onready var camera = $cameraController/Camera3D

@export var roll_speed := 5.0
var ball_mesh: MeshInstance3D

var movement_input = Vector2.ZERO

# Track jumps
var jump_count := 0
const MAX_JUMPS := 2 

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	# Assuming the ball mesh is a child of the current node
	ball_mesh = $MeshInstance3D # Use the correct node path if needed (e.g., "$MeshInstance3D")

func _physics_process(delta: float) -> void:
	movement(delta)
	jump(delta)
	rotate_ball(delta)
	move_and_slide()

func movement(delta: float) -> void:
	movement_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").rotated(-camera.global_rotation.y)
	
	# Convert the 2D input to a 3D vector
	var dir = Vector3(movement_input.x, 0, movement_input.y)

	if is_on_floor():
		# Reset jump count when on the floor
		jump_count = 0
		var is_running: bool = Input.is_action_pressed("sprint")
		
		if movement_input != Vector2.ZERO:
			var current_speed = run_speed if is_running else normal_speed
			dir *= current_speed
			# Apply direction to velocity
			velocity.x = dir.x
			velocity.z = dir.z
			
		else:
			# No input, smooth deceleration to stop the ball
			velocity.x = move_toward(velocity.x, 0, base_speed)
			velocity.z = move_toward(velocity.z, 0, base_speed)

	else:
		# Apply gravity when not on the floor
		if velocity.y > 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta

func jump(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# First jump when on the floor
			velocity.y = jump_velocity  # Apply initial jump velocity
			jump_count = 1  # Set jump count to 1 when first jump is performed

		elif jump_count < MAX_JUMPS:
			# Allow second jump while in the air
			velocity.y = jump_velocity  # Apply the same jump velocity for the second jump
			jump_count = 2  # Set jump count to 2 after the second jump

func rotate_ball(delta: float) -> void:
	if ball_mesh:
		# Get the horizontal velocity (ignore vertical movement)
		var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
		
		if horizontal_velocity.length() > 0:
			# Calculate rotation axis (90 degrees from movement direction)
			var rotation_axis = horizontal_velocity.cross(Vector3.UP).normalized()
			
			# Calculate how much to rotate
			var rotation_amount = horizontal_velocity.length() * roll_speed * delta
			
			# Rotate the ball around the correct axis
			ball_mesh.rotate_object_local(rotation_axis, rotation_amount)
			
func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		

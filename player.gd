extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 4.5
const ROTATE_SPEED = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var canMove = true

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	# if the direction is non-zero, set the velocity to the direction multiplied by the max speed
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else: # otherwise move towards 0 velocity
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# get the input velocity from the controller
	var sideRot = Input.get_axis("rotate_left", "rotate_right")
	
	if canMove:
		# rotate the player according to the input
		rotate(Vector3.DOWN, sideRot*delta*ROTATE_SPEED)
		
		# move the player
		move_and_slide()

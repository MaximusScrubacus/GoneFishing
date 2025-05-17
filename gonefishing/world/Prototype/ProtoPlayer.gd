extends CharacterBody3D

const JUMP_VELOCITY = 4.5
const SPEED = 5.0
const GRAVITY = -6.0
var glide_factor = 0.2

var is_gliding = false

@onready var pivot: Node3D = %Head
@export var sensitivity = 0.5
@onready var bobber: Node3D = %Bobber
@onready var camera_position: Camera3D = $Head/SpringArm/ThirdPersonCamera

#Camera Control 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left-click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90),deg_to_rad(45))
	
		
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_in"):
		camera_position.transform.origin.z = -1
#Jumping / Falling
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_gliding:
		velocity.y += GRAVITY * delta
	elif not is_on_floor() and is_gliding:
		velocity.y += GRAVITY * delta * glide_factor
		print("Test")
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("glide") && not is_on_floor():
		is_gliding = true
	else:
		is_gliding = false
		
		
	var input_dir := Input.get_vector("left", "right", "up", "down") 
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

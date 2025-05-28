extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 6
const CLIMBING_SPEED = 3.0
const VAULT_VELOCITY = 3.0
var mouse_sens = 0.1

@onready var on_wall: RayCast3D = $Visual/On_Wall
@onready var still_on_wall: RayCast3D = $Visual/Still_On_Wall
@onready var sasha: Node3D = $Visual/Sasha
@onready var animation_player: AnimationPlayer = $Visual/Sasha/AnimationPlayer
@onready var visual: Node3D = $Visual
@onready var pivot: Node3D = $Pivot


var is_climbing = false
var is_gliding = false
var glide_speed = -200
var last_direction = Vector3.ZERO
var rotation_speed = 2.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	_camera_movement(event)
func _physics_process(delta: float) -> void:
	_gliding(delta)
	_climbing()
	_movement(delta)
	# Add the gravity.
	_gravity(delta)
	# Handle jump.
	_jump()
	move_and_slide()

func _climbing():
	if on_wall.is_colliding():
		if still_on_wall.is_colliding():
			if is_on_floor():
				is_climbing = false
			else :
				is_climbing = true
				animation_player.play("Climbing")
		else:
			is_climbing = false
			animation_player.play("Climbing_End")
			velocity.y = VAULT_VELOCITY
	else:
		is_climbing = false	
	if is_climbing:
		velocity = Vector3.ZERO
		var move_direction = Vector3.ZERO
		var rot = -(atan2(on_wall.get_collision_point().z, on_wall.get_collision_normal().x)- PI/2)
		move_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		move_direction.y = Input.get_action_strength("up") - Input.get_action_strength("down")
		move_direction = Vector3(move_direction.x,move_direction.y,0).rotated(Vector3.UP,rot).normalized()
		velocity.x = -move_direction.x * CLIMBING_SPEED
		velocity.y += move_direction.y * CLIMBING_SPEED
		velocity.z = -move_direction.z * CLIMBING_SPEED
		
		if move_direction != Vector3.ZERO:
			animation_player.play("Climbing")
		elif move_direction >= Vector3.ZERO:
			animation_player.play("Climbing_Idle")
func _movement(_delta):
	if !is_climbing:
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			animation_player.play("Walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			animation_player.play("Idle")
func _camera_movement(event: InputEvent) -> void:
	if !is_climbing:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	if is_climbing and event is InputEventMouseMotion:
		pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-45), deg_to_rad(15))
func _gliding(delta):
	if !is_on_floor() and Input.is_action_pressed("glide"):
		is_gliding = true
	else:
		is_gliding = false
	if is_gliding:
		animation_player.play("Fall")
		velocity.y = glide_speed * delta
func _gravity(delta):
	if not is_on_floor() and !is_climbing and !is_gliding:
		velocity += get_gravity() * delta
func _jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !is_climbing and !is_gliding:
		velocity.y = JUMP_VELOCITY

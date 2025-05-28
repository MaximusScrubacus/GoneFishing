extends CharacterBody3D

@onready var on_wall: RayCast3D = $ClimbingCast/OnWall
@onready var wall_check: RayCast3D = $ClimbingCast/WallCheck
@onready var head: Node3D = $Head
@onready var player_mesh: Node3D = $Sasha
@onready var stick_point_holder: Marker3D = $ClimbingCast/StickPointHolder
@onready var stick_point: Marker3D = $ClimbingCast/StickPointHolder/StickPoint
@onready var animation_player: AnimationPlayer = $Sasha/AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const END_CLIMB_JUMP = 2.5
const CLIMB_SPEED = 1.5
var is_climbing: bool = false
var Mouse_Sensitivity: int = 0.05

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left-click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * Mouse_Sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * Mouse_Sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90),deg_to_rad(45))


func _physics_process(delta: float) -> void:
	climbing()
	if is_climbing:
		player_mesh.rotation.y = -(atan2(wall_check.get_collision_normal().z,wall_check.get_collision_normal().x)- PI/2)
	# Add the gravity.
	if !is_climbing:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if !is_climbing:
		var input_dir := Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			player_mesh.basis = lerp(player_mesh.basis,Basis.looking_at(direction), 10.0 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	if is_climbing:
		velocity = Vector3.ZERO
		
		stick_point_holder.global_transform.origin = on_wall.get_collision_point()
		self.global_transform.origin.x = stick_point.global_transform.origin.x
		self.global_transform.origin.z = stick_point.global_transform.origin.z
		
		var move_direction = Vector3.ZERO
		var rot = -(atan2(on_wall.get_collision_point().z, on_wall.get_collision_normal().x)- PI/2)
		move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		move_direction.y = Input.get_action_strength("up") - Input.get_action_strength("down")
		move_direction = Vector3(move_direction.x,move_direction.y,0).rotated(Vector3.UP,rot).normalized()
		velocity.x = -move_direction.x * CLIMB_SPEED
		velocity.y += move_direction.y * CLIMB_SPEED
		velocity.z = -move_direction.z * CLIMB_SPEED
		
		if move_direction != Vector3.ZERO:
			animation_player.play("Climbing")
		else:
			animation_player.play("Climbing_Idle")
		
	move_and_slide()
	
func climbing():
	if on_wall.is_colliding():
		if wall_check.is_colliding():
			is_climbing = true
		else:
			animation_player.play("Climbing_End")
			velocity.y = END_CLIMB_JUMP
			is_climbing = false
	else:
		is_climbing = false	
	

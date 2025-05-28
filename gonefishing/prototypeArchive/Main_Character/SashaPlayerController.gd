extends CharacterBody3D

const JUMP_VELOCITY = 4.5
@export var sensitivity = 0.5

@onready var sasha: Node3D = $Sasha
@onready var pivot: Node3D = %Head
@onready var bobber: Node3D = %Bobber
@onready var camera_position: Camera3D = $Head/SpringArm/ThirdPersonCamera
@onready var body: CollisionShape3D = $CollisionShape3D
@onready var animation_player: AnimationPlayer = $Sasha/AnimationPlayer
@onready var wall_check: RayCast3D = $WallCheck
@onready var still_wall: RayCast3D = $StillWall



signal open_inventory
var can_move = true
var in_water = false
var is_climbing: bool = false
#Camera Control 
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseMotion and can_move:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		pivot.rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90),deg_to_rad(45))
	if event.is_action_pressed("inventory"):
		open_inventory.emit()
		can_move = not can_move
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_in"):
		camera_position.transform.origin.z = -1
#Jumping / Falling
func _physics_process(delta: float) -> void:
	climbing()
	if in_water:
		animation_player.play("Swim_Idle")
		
	if !is_climbing:	
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_move:
		velocity.y = JUMP_VELOCITY

	


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("Water"):
		in_water = true
		print("Inwater")

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("Water"):
		in_water = false
		print("onland")
		
func climbing():
	if wall_check.is_colliding():
			if still_wall.is_colliding():
				is_climbing = true
			else:
				velocity.y = JUMP_VELOCITY
				is_climbing = false
	else:
		is_climbing = false	

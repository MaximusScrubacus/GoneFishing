class_name Moving
extends State

@export var animation_player: AnimationPlayer
@export var player: CharacterBody3D
@export var head : Node3D
@export var particles: Node3D

const  SPEED: float = 5.0
var sprint_speed: float = 1
var can_move = true

func Enter():
	animation_player.play("Walk")
	particles.show()
func Update(_delta:float):
	if player.velocity.x == 0 and player.velocity.z == 0 and player.velocity.y == 0 and player.is_on_floor():
		state_transition.emit(self, "Idle")
	if Input.is_action_just_pressed("jump"):
		state_transition.emit(self,"Jumping")
	if Input.is_action_just_pressed("sprint"):
		sprint_speed = 1.75
		animation_player.play("Run")
	elif Input.is_action_just_released("sprint"):
		sprint_speed = 1.0
		animation_player.play("Walk")
	move()
func Exit():
	animation_player.stop()
	particles.hide()
func move():
	var input_dir := Input.get_vector("left", "right", "up", "down") 
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and can_move:
		player.velocity.x = direction.x * SPEED * sprint_speed
		player.velocity.z = direction.z * SPEED * sprint_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
		
	player.move_and_slide()



func _on_player_2_open_inventory() -> void:
	can_move = not can_move

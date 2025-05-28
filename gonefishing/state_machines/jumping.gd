class_name Jumping
extends State

@export var animation_player : AnimationPlayer
@export var player : CharacterBody3D
const SPEED: float = 5.0

func Enter():
	animation_player.play("Jump")
func Update(_delta:float):
	move()
	if player.is_on_floor():
		state_transition.emit(self,"Idle")
	if Input.is_action_just_pressed("glide"):
		state_transition.emit(self,"Gliding")
func Exit():
	animation_player.stop()
func move():
	var input_dir := Input.get_vector("left", "right", "up", "down") 
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	
	player.move_and_slide()

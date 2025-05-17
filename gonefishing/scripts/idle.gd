class_name Idle
extends State

@export var animation_player: AnimationPlayer


func Enter():
	animation_player.play("Idle")
	pass
func Update(_delta:float):
	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_transition.emit(self, "Moving")
	if Input.is_action_just_pressed("jump"):
		state_transition.emit(self,"Jumping")
func Exit():
	animation_player.stop()

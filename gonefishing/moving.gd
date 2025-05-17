class_name Moving
extends State

@export var animation_player: AnimationPlayer
@export var player: CharacterBody3D
func Enter():
	animation_player.play("Walk")
func Update(_delta:float):
	if player.velocity.x == 0 and player.velocity.z == 0 and player.velocity.y == 0 and player.is_on_floor():
		state_transition.emit(self, "Idle")
func Exit():
	pass

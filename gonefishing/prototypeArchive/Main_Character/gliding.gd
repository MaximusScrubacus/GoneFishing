class_name Gliding
extends State

@export var animation_player : AnimationPlayer
@export var player : CharacterBody3D
var is_gliding: bool = true	
func Enter():
	pass
func Update(_delta:float):
	if player.is_on_floor():
		state_transition.emit(self, "Idle")
	if not player.is_on_floor() and is_gliding:
		state_transition.emit(self, "Jumping")
func Exit():
	pass

	

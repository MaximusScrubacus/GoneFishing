class_name Fishing
extends State

@export var animation_player : AnimationPlayer
@export var player : CharacterBody3D

func Enter():
	pass
func Update(_delta:float):
	if player.is_clmbing:
		print("Climbing")
func Exit():
	pass

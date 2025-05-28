class_name  StateMachineController
extends Node

var states: Dictionary = {}
var current_state: State
@export var initial_state: State 

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func change_state(old_state : State, new_state_name: String):
	if old_state != current_state:
		print("Invalid change_state trying from:" + old_state.name + "but currently in:" + current_state.name)
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("New State is empty!")
		return
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state

func _process(delta: float) -> void:
	if current_state:
			current_state.Update(delta)

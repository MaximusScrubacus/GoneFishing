extends Node3D

@onready var bobber: CharacterBody3D = %Bobber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	self.global_position = bobber.global_position
	print("def")


func _on_area_3d_body_entered(body: Node3D) -> void:
	self.global_position = bobber.global_position
	print("suc")

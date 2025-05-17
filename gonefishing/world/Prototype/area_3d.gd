extends Area3D

@onready var player_2: Node3D = $"../Player2"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_body_entered(body: Node3D) -> void:
	#print("Ready To Fish1")


func _on_area_entered(area: Area3D) -> void:
	print("Ready To Fish2")

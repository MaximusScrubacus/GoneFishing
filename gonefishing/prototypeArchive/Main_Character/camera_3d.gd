extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var ZoomSpeed = Vector3(0.0,0.0,0.5)

	if Input.is_action_just_pressed("scroll_in"):
		position = + ZoomSpeed
	if Input.is_action_just_pressed("scroll_out"):
		position = + ZoomSpeed

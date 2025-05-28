extends SpringArm3D

@export var ZoomSpeed = 0.25
@export var MinZoom = 1.0
@export var MaxZoom = 5.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("scroll_in"):
		spring_length = clamp(spring_length, MinZoom, MaxZoom) - ZoomSpeed
	if Input.is_action_just_pressed("scroll_out"):
		spring_length = clamp(spring_length, MinZoom, MaxZoom) + ZoomSpeed

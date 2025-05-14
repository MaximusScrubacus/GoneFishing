extends RayCast3D

@onready var fishing_line: Node3D = $"../../Sasha/Armature/Skeleton3D/RodHolder/FishingLine"
@onready var rod_tip: Node3D = $"../../Sasha/Armature/Skeleton3D/RodHolder/RodTip"
@onready var bobber: Node3D = $"../../../Bobber"
@onready var range_indicator: Sprite3D = $RangeIndicator
@onready var skin_player: AnimationPlayer = $"../../AnimalCrossing3/AnimationPlayer"

var Cast = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		bobber.global_position = get_collision_point()
		bobber.visible = true	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if self.is_colliding():
		range_indicator.visible = true
		range_indicator.global_position = get_collision_point()
		update_cast()
	else:
		range_indicator.visible = false
		fishing_line.visible = false
		
#I deleted the fishing node 
func update_cast():
	fishing_line.visible = true
	var dist = rod_tip.global_position.distance_to(bobber.global_position)
	
	fishing_line.look_at(bobber.global_position)
	fishing_line.scale = Vector3(1, 1, dist)
	

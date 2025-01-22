extends Camera3D
var look_dir = Vector3()
var mouse_sens = 0.001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && 	Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_dir = event.relative * 0.001
		rotate_y(-event.relative.x * mouse_sens)
		rotation.x = clamp(rotation.x, -1.2, 1.2)

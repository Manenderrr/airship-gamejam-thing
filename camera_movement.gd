extends Camera3D

var mouse_sensitivity = 0.005

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, deg_to_rad(-60), deg_to_rad(30))
	
func _unhandled_input(event):
	if event.is_action_pressed("exit_test_mode"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("enter_test_mode"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

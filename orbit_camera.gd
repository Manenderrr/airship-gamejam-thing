extends Node3D

@export var sensivity: float = 0.01

var rotation_x: float = 0.0
var rotation_y: float = 0.0

const HALF_PI = PI / 2

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_delta = event.screen_relative * sensivity
		rotation_x += mouse_delta.x
		rotation_y = clampf(rotation_y - mouse_delta.y, -HALF_PI, HALF_PI)
		print(rotation_y)

		basis = Basis.IDENTITY
		rotate_object_local(Vector3.UP, -rotation_x)
		rotate_object_local(Vector3.LEFT, rotation_y)

	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

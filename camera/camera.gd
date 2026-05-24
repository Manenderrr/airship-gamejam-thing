extends Node3D

const HALF_PI = PI / 2

## The intended rotation of the camera root.
@export_custom(PROPERTY_HINT_RANGE, "-360.0,360.0,0.1,suffix:°") var camera_rotation: Vector3 = Vector3.ZERO

## By how many radians will a single screen pixel worth of mouse movement rotate the camera root.
@export_custom(PROPERTY_HINT_NONE, "suffix:rad/px") var sensivity: float = 0.005
## The camera itself, mostly to change its distance relative to the root.
@export var camera: Camera3D

@export_group("Zoom", "zoom_")
## How close is the camera allowed to be.
@export_range(0.1, 100.0, 1.0, "or_greater", "exp", "suffix:m") var zoom_min_camera_distance: float = 10
## How far is the camera allowed to be.
@export_range(10.0, 1000.0, 1.0, "or_less", "exp", "suffix:m") var zoom_max_camera_distance: float = 100
## How long will the zoom animation take.
@export_range(0.01, 1, 0.1, "or_greater", "or_less", "suffix:s") var zoom_animation_duration: float = 0.1

var zoom_tween: Tween

## Whether the camera is _rotating with mouse movement and the mouse pointer is captured.
var _rotating: bool = false

func lock():
	_rotating = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
func unlock():
	_rotating = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func zoom(multiplier: float):
	if zoom_tween: zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, ^"camera:position:z", camera.position.z * multiplier, zoom_animation_duration)

func _ready():
	assert(is_instance_valid(camera), "Camera is not set")
	update_rotation()

func update_rotation():
	basis = Basis.IDENTITY
	rotate_object_local(Vector3.UP, camera_rotation.x)
	rotate_object_local(Vector3.LEFT, camera_rotation.y)

func _input(event: InputEvent) -> void:
	if _rotating:
		if event is InputEventMouseMotion:
			var mouse_delta = event.screen_relative * sensivity
			camera_rotation.x -= mouse_delta.x
			camera_rotation.y = clampf(camera_rotation.y + mouse_delta.y, -HALF_PI, HALF_PI)
			
			update_rotation()

			get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if _rotating:
		if event is InputEventMouseButton:
			if event.is_action_pressed("camera_zoom_out"): zoom(2)
			elif event.is_action_pressed("camera_zoom_in"): zoom(0.5)

			get_viewport().set_input_as_handled()

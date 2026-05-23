extends Node3D

@onready var shipment_menu: = %ShipmentMenu

@export var sensivity: float = 0.01
@export var camera: Camera3D

@export_group("Zoom", "zoom_")
@export_range(0.1, 100.0, 1.0, "or_greater", "exp", "suffix:m") var zoom_min_camera_distance: float = 10
@export_range(10.0, 1000.0, 1.0, "or_less", "exp", "suffix:m") var zoom_max_camera_distance: float = 100
@export_range(0.01, 1, 0.1, "or_greater", "or_less", "suffix:s") var zoom_animation_duration: float = 0.1

var zoom_tween: Tween

var rotation_x: float = 0.0
var rotation_y: float = 0.0

const HALF_PI = PI / 2

func zoom(multiplier: float):
	if zoom_tween: zoom_tween.kill()
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, ^"camera:position:z", camera.position.z * multiplier, zoom_animation_duration)

func _ready():
	assert(is_instance_valid(camera), "Camera is not set")

func _input(event: InputEvent) -> void:
	if(shipment_menu.in_shipment_menu == false):
		if event is InputEventMouseMotion:
			var mouse_delta = event.screen_relative * sensivity
			rotation_x += mouse_delta.x
			rotation_y = clampf(rotation_y - mouse_delta.y, -HALF_PI, HALF_PI)

			basis = Basis.IDENTITY
			rotate_object_local(Vector3.UP, -rotation_x)
			rotate_object_local(Vector3.LEFT, -rotation_y)
		
		elif event is InputEventMouseButton:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			if event.is_action_pressed("camera_zoom_out"): zoom(2)
			elif event.is_action_pressed("camera_zoom_in"): zoom(0.5)
		elif event is InputEventKey:
			if event.is_action_pressed("ui_cancel"):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

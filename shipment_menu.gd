extends Control

@onready var camera_movement: = %Camera3D
@onready var shipment_menu: = %ShipmentMenu
var in_shipment_menu: bool = false

func _ready() -> void:
	shipment_menu_disappear()

func _on_button_pressed() -> void:
	shipment_menu_disappear()

func shipment_menu_appear() -> void:
	shipment_menu.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	in_shipment_menu = true

func shipment_menu_disappear() -> void:
	shipment_menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	in_shipment_menu = false

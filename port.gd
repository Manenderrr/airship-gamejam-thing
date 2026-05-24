extends StaticBody3D

@onready var shipment_menu: Control
@onready var airship: RigidBody3D
@onready var mission_system: Node3D
@export var port_number: int
@export var products: Product


func _ready() -> void:
	shipment_menu = %ShipmentMenu
	airship = %airship
	mission_system = %Ports

func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		mission_system.port_number = port_number
		shipment_menu.shipment_menu_appear()
		mission_system.new_mission()
		print(airship.mission_number)

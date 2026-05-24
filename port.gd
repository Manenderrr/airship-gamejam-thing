extends StaticBody3D

@onready var shipment_menu: Control = %ShipmentMenu
@onready var airship: RigidBody3D = %Airship
@onready var mission_system: Node3D = $".."
@export var port_number: int
@export var products: Array[Product] = []

var in_mission: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	var check_products = 0
	if body.is_in_group("Player"):
		
		if mission_system.mission_number == port_number:
			for prod in products:
				if prod.mission_amount <= prod.amount:
					check_products += 1
			if check_products >= products.size():
				print("great")
				mission_system.ended_mission()

		if !in_mission:
			mission_system.port_number = port_number
			shipment_menu.shipment_menu_appear()
			mission_system.new_mission()

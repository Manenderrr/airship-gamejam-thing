extends Area3D

@onready var shipment_menu: = %ShipmentMenu

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		shipment_menu.shipment_menu_appear()

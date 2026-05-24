extends HBoxContainer

@export var is_add_container: bool = false
var item: Product

@onready var info: Label = %Info
@onready var amount_info: Label = %AmountInfo
@onready var amount = %Amount

var airship: RigidBody3D
var past_acts_info: Label

func _ready() -> void:
	if item and past_acts_info:
		info.text = item.name + ": weight = " + str(item.weight) + ", size = " + str(item.size)
		update_info()

func update_info():
	past_acts_info.text = "Current airship weight: " + str(snapped(airship.mass, 0.01)) + " Remaining crate space: " + str(airship.crate_size - item.amount * item.size)
	amount_info.text = "Amount: " + str(item.amount)

func _on_add_button_pressed() -> void:
	if is_add_container:
		item.amount += amount.value
		if airship.crate_size >= item.amount * item.size:
			airship.add_mass()
		else:
			while airship.crate_size < item.amount * item.size:
				item.amount -= 1
			airship.add_mass()
	elif !is_add_container:
		item.amount -= amount.value
		airship.remove_mass()
	update_info()

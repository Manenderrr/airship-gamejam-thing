extends HBoxContainer

@export var is_add_container: bool = false
@export var item: Product

@onready var info: Label = %Info
@onready var amount = %Amount

var airship: RigidBody3D
var past_acts_info: Label

func _ready() -> void:
	if item:
		info.text = item.name + ": weight = " + str(item.weight) + ", size = " + str(item.size)

func _on_add_button_pressed() -> void:
	if is_add_container:
		item.amount += amount.value
		if airship.crate_size >= item.amount * item.size:
			airship.add_mass()
		else:
			while airship.crate_size < item.amount * item.size:
				item.amount -= 1
			airship.add_mass()
		past_acts_info.text = "Added: " + str(snapped(amount.value, 1)) + " " + item.name + ". Current weight: " + str(snapped(airship.mass, 0.01))
		airship.crate_size -= item.amount * item.size

	elif !is_add_container:
		item.amount += amount.value
		airship.remove_mass()
		past_acts_info.text = "Removed: " + str(snapped(amount.value, 1)) + " " + item.name + ". Current weight: " + str(snapped(airship.mass, 0.01))
		airship.crate_size += item.amount * item.size

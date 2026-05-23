extends Node

@export var info: Label

@onready var amount = %Amount
@export var item: Product
@onready var airship: RigidBody3D = %Airship


func _ready() -> void:
	info.text = item.name + ": weight = " + str(item.weight) + ", size = " + str(item.size)

func _on_pressed() -> void:
	item.amount = amount.value
	airship.change_mass()

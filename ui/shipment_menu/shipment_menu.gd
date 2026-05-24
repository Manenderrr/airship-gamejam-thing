extends Control

signal on_appear
signal on_disappear

@export var airship: RigidBody3D
@onready var past_acts_info: Label = %PastActsInfo
@export var products: Array[Product] = []

@onready var parent_of_add_containers: Node = %"AddContainers(VBox)"
@export var add_container_scene: PackedScene

@onready var parent_of_remove_containers: Node = %"RemoveContainers(VBox)"
@export var remove_container_scene: PackedScene


func _ready() -> void:
	airship = %Airship
	
	shipment_menu_disappear()
	add_add_containers()
	add_remove_containers()

func _on_button_pressed() -> void:
	shipment_menu_disappear()

func shipment_menu_appear() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	on_appear.emit()

func shipment_menu_disappear() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	on_disappear.emit()

func add_add_containers():
	for prod in products:
		if prod:
			var new_act_button_scene = add_container_scene.instantiate()

			new_act_button_scene.past_acts_info = past_acts_info
			new_act_button_scene.airship = airship
			new_act_button_scene.item = prod

			parent_of_add_containers.add_child(new_act_button_scene)

func add_remove_containers():
	for prod in products:
		if prod:
			var new_act_button_scene = remove_container_scene.instantiate()

			new_act_button_scene.past_acts_info = past_acts_info
			new_act_button_scene.airship = airship
			new_act_button_scene.item = prod

			parent_of_remove_containers.add_child(new_act_button_scene)

extends Control

var in_shipment_menu: bool = false

@export var products: Array[Product] = []
@export var airship: RigidBody3D

@onready var past_acts_info: Label = %PastActsInfo

@onready var parent_of_add_containers: VBoxContainer = %"AddContainers(VBox)"
var add_container_scene = preload("res://scenes/add_container.tscn")

@onready var parent_of_remove_containers: VBoxContainer = %"RemoveContainers(VBox)"
var remove_container_scene = preload("res://scenes/remove_container.tscn")


func _ready() -> void:
	shipment_menu_disappear()
	add_add_containers()
	add_remove_containers()

func _on_button_pressed() -> void:
	shipment_menu_disappear()

func shipment_menu_appear() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	in_shipment_menu = true

func shipment_menu_disappear() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	in_shipment_menu = false

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

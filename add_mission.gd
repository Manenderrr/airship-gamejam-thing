extends Node

@export var products: Array[Product] = []
@export var ports: Array[StaticBody3D] = []
var port_number: int
var mission_number: int = -1
var max_misiion_item_amount = 5
var in_mission: bool = false

signal mission_added(prod_name1: String, prod1: int, prod_name2: String,prod2: int,prod_name3: String, prod3: int, mission_number: int)

func new_mission():
	var ports_count = 0
	
	var current_mission_item_amount = 0
	var rand_mission_item_amount = 0
	
	if !in_mission:
		while mission_number == -1:
			mission_number = randi_range(0, ports.size() - 1)
			if mission_number == port_number:
				mission_number = -1
		for port in ports:
			if ports_count == port_number:
				port.in_mission = false
			else:
				port.in_mission = true
			ports_count += 1

		for prod in products:
			rand_mission_item_amount = randi_range(0, max_misiion_item_amount)
			current_mission_item_amount += rand_mission_item_amount
			while max_misiion_item_amount < current_mission_item_amount:
				current_mission_item_amount -= 1
				rand_mission_item_amount -= 1
			prod.mission_amount = rand_mission_item_amount
			print(prod.name + " " + str(prod.mission_amount))

		mission_added.emit(products[0].name, products[0].mission_amount, products[1].name, products[1].mission_amount, products[2].name, products[2].mission_amount, mission_number)

		in_mission = true

		print(mission_number)

func ended_mission():
	mission_number = -1
	in_mission = false
	for port in ports:
			port.in_mission = false

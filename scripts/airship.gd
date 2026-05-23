extends RigidBody3D

@export var weight: float = 2000.0
const air_density: float = 1.190
const airship_density: float = 0.0899
const g: float = 9.8

@export_group("UI")
@onready var shipment_menu: = %ShipmentMenu

@export_group("Cargo")
@export var products: Array[Product] = []
var crate_size: float = 100:
	set(value):
			crate_size = max(0, value)

@export_group("Ballast")
@export var airship_capasity: float = 50000.0
@export var air_in_ballast: float:
	set(value):
		air_in_ballast = clamp(value, 0, airship_capasity)
		air_changed_fraction.emit(air_in_ballast / airship_capasity)

@export var air_ballast_pump_speed :float = 1000.0

signal air_changed_fraction(new_fraction: float)

@export_group("Engine")
@export var acceleration: float = 15000.0
@export var torque: float = 37500.0
@export var acceleration_friction: float = 10.0
@export var torque_friction: float = 10.0

func _ready() -> void:
	linear_damp = acceleration_friction
	angular_damp = torque_friction

	mass = weight
	for prod in products:
		if prod:
			mass += prod.weight * prod.amount

	air_in_ballast = mass / (air_density - airship_density)

func _process(delta: float) -> void:
	if shipment_menu.in_shipment_menu == false:
		if Input.is_action_pressed("takeoff"):
			air_in_ballast -= air_ballast_pump_speed * delta
		if Input.is_action_pressed("landing"):
			air_in_ballast += air_ballast_pump_speed * delta


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if shipment_menu.in_shipment_menu == false:
		var thrust_axis = Input.get_axis("airship_back", "airship_forward")
		state.apply_central_force(basis.x * thrust_axis * acceleration)

		var torque_axis = Input.get_axis("airship_left", "airship_right")
		state.apply_torque(Vector3(0, torque_axis * torque, 0))

	#airship takeoff and landing
	state.apply_central_force(basis.y * g * air_in_ballast * (air_density - airship_density))

func add_mass():
	for prod in products:
		var new_mass: float
		if prod:
			if crate_size >= prod.size * prod.amount:
				new_mass = prod.weight * prod.amount
				air_in_ballast = mass / (air_density - airship_density)
		mass += new_mass

func remove_mass():
	for prod in products:
		var new_mass: float
		if prod:
			if crate_size >= prod.size * prod.amount:
				new_mass = prod.weight * prod.amount
				air_in_ballast = mass / (air_density - airship_density)
		mass -= new_mass

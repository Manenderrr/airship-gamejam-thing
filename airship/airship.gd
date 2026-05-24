extends RigidBody3D

## The mass of the airship itself.
@export var initial_mass: float = 2000.0

## The totol mass of the cargo.
var cargo_mass: float = 0
func update_cargo_mass():
	for prod in products:
		if prod:
			if crate_size >= prod.size * prod.amount:
				cargo_mass += prod.weight * prod.amount

const AIR_DENSITY: float = 1.190
const AIRSHIP_DENSITY: float = 0.0899
const g: float = 9.8

@export_group("Cargo")
@export var products: Array[Product] = []
var crate_size: float = 100:
	set(value):
		crate_size = max(0, value)

@export_group("Ballast")
@export var air_capacity: float = 50000.0:
	set(value):
		air_capacity = value
		air_capacity_changed.emit(value)
signal air_capacity_changed(new_capacity: float)

var air_in_ballast: float:
	set(value):
		air_in_ballast = clampf(value, 0, air_capacity)
		air_changed.emit((g * air_in_ballast * (AIR_DENSITY - AIRSHIP_DENSITY) - g * mass) / mass)
signal air_changed(new_value: float)

@export var air_ballast_pump_speed: float = 1000.0

@export_group("Engine")
@export var thrust_change_speed: float = 1500.0
@export var max_thrust: float = 15000.0:
	set(value):
		max_thrust = value
		max_thrust_changed.emit(max_thrust)
		min_thrust_changed.emit(-max_thrust)
signal max_thrust_changed(new_max_thrust: float)
signal min_thrust_changed(new_min_thrust: float)
@export var stabilization_force: float = 15000.0
@export var stabilization_damp: float = 5.0


var thrust: float = 0:
	set(value):
		thrust = clampf(value, -max_thrust, max_thrust)
		thrust_changed.emit(thrust/mass)
signal thrust_changed(new_thrust: float)

@export var torque: float = 37500.0

@export_group("Controls")
## Whether the player can control the airship.
@export var controls_enabled: bool = true:
	set(value):
		controls_enabled = value
		on_controls_change.emit(value)
		if value: on_controls_enable.emit()
		else: on_controls_disable.emit()

func enable_controls():
	controls_enabled = true
func disable_controls():
	controls_enabled = false

signal on_controls_enable
signal on_controls_disable
signal on_controls_change(new_state: bool)

func _ready() -> void:
	# Trigger "changed" signals to initialise things that depend on them
	air_changed.emit(air_in_ballast)
	air_capacity_changed.emit(air_capacity)
	thrust_changed.emit(thrust)
	max_thrust_changed.emit(max_thrust)
	min_thrust_changed.emit(-max_thrust)

	mass = initial_mass
	for prod in products:
		if prod:
			mass += prod.weight * prod.amount

	air_in_ballast = mass / (AIR_DENSITY - AIRSHIP_DENSITY)

func _process(delta: float) -> void:
	if controls_enabled:
		air_in_ballast += air_ballast_pump_speed * delta * Input.get_axis("airship_descend", "airship_ascend")

		thrust += Input.get_axis("airship_back", "airship_forward") * thrust_change_speed * delta
	else:
		thrust = 0
		air_in_ballast = mass / (AIR_DENSITY - AIRSHIP_DENSITY)
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if controls_enabled:
		state.apply_central_force(-basis.z * thrust)

		var yaw_axis: = Input.get_axis("airship_yaw_right", "airship_yaw_left")
		state.apply_torque(basis.y * yaw_axis * torque)

	#airship takeoff and landing
	state.apply_central_force(Vector3.UP * g * air_in_ballast * (AIR_DENSITY - AIRSHIP_DENSITY))

func _physics_process(_delta: float) -> void:
	var current_up: Vector3 = global_transform.basis.y
	var target_up: Vector3 = Vector3.UP
	
	var error_axis: Vector3 = current_up.cross(target_up)
	
	if error_axis.length() > 0.001:
		var torque: Vector3 = error_axis * stabilization_force - angular_velocity * stabilization_damp * mass
		apply_torque(torque)

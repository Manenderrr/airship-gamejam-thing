extends RigidBody3D

@export var weight: float = 2000.0
var change_mass: float = 0
const air_density: float = 1.190
const airship_density: float = 0.0899
const g: float = 9.8

@export_group("Cargo")
@export var products: Array[Product] = []
var crate_size: float = 100:
	set(value):
		crate_size = max(0, value)

@export_group("Ballast")
@export var envelope: Node3D
@export var airship_capacity: float = 50000.0
@export var air_in_ballast: float:
	set(value):
		air_in_ballast = clamp(value, 0, airship_capacity)
		air_changed_fraction.emit(air_in_ballast / airship_capacity)

@export var air_ballast_pump_speed :float = 1000.0

signal air_changed_fraction(new_fraction: float)

@export_group("Engine")
@export var acceleration: float = 15000.0
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
	assert(envelope, "envelope is not set")

	mass = weight
	for prod in products:
		if prod:
			mass += prod.weight * prod.amount

	air_in_ballast = mass / (air_density - airship_density)

func _process(delta: float) -> void:
	if controls_enabled:
		if Input.is_action_pressed("airship_ascend"):
			air_in_ballast -= air_ballast_pump_speed * delta
		if Input.is_action_pressed("airship_descend"):
			air_in_ballast += air_ballast_pump_speed * delta * Input.get_axis("airship_descend", "airship_ascend")

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if controls_enabled:
		var thrust_axis: = Input.get_axis("airship_back", "airship_forward")
		state.apply_central_force(-basis.z * thrust_axis * acceleration)

		var yaw_axis: = Input.get_axis("airship_yaw_right", "airship_yaw_left")
		state.apply_torque(basis.y * yaw_axis * torque)

		var pitch_axis: = Input.get_axis("airship_pitch_down", "airship_pitch_up")
		state.apply_torque(basis.x * pitch_axis * torque)

		var roll_axis: = Input.get_axis("airship_roll_right", "airship_roll_left")
		state.apply_torque(basis.z * roll_axis * torque)

	#airship takeoff and landing
	state.apply_force(Vector3.UP * g * air_in_ballast * (air_density - airship_density), envelope.global_position - global_position)

func add_mass():
	for prod in products:
		if prod:
			if crate_size >= prod.size * prod.amount:
				change_mass += prod.weight * prod.amount
	to_change_mass()

func remove_mass():
	for prod in products:
		if prod:
			change_mass += prod.weight * prod.amount
	to_change_mass()

func to_change_mass():
	mass = change_mass + weight
	air_in_ballast = mass / (air_density - airship_density)
	change_mass = 0

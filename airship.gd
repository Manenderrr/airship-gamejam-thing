extends RigidBody3D


var air_density: float = 1.190
var airship_density: float = 0.0899
var g: float = 9.8

@export var airship_capasity: float = 4000.0
@export var air_ballast_space :float = 2000.0:
	set(value):
		air_ballast_space = clamp(value, 0, airship_capasity)
@export var waste_air_ballast :float = 100.0

@export var acceleration: float = 15000.0
@export var torque: float = 37500.0
@export var acceleration_friction: float = 10.0
@export var torque_friction: float = 10.0

func _ready() -> void:
	linear_damp = acceleration_friction
	angular_damp = torque_friction

func _process(delta: float) -> void:
	if Input.is_action_pressed("takeoff"):
		air_ballast_space -= waste_air_ballast * delta
	if Input.is_action_pressed("landing"):
		air_ballast_space += waste_air_ballast * delta


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var thrust_axis = Input.get_axis("airship_back", "airship_forward")
	state.apply_central_force(basis.x * thrust_axis * acceleration)

	var torque_axis = Input.get_axis("airship_left", "airship_right")
	state.apply_torque(Vector3(0, torque_axis * torque, 0))

	#airship takeoff and landing
	state.apply_central_force(basis.y * g * air_ballast_space * (air_density - airship_density))

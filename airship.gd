extends RigidBody3D

@export var acceleration: float = 20.0
@export var torque: float = 50.0

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var thrust_axis = Input.get_axis("airship_back", "airship_forward")
	state.apply_central_force(basis.z * thrust_axis * acceleration)

	var torque_axis = Input.get_axis("airship_left", "airship_right")
	state.apply_torque(Vector3(0, torque_axis * torque, 0))

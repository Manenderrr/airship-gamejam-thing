class_name HUD
extends Control

@export var y_vector_info: Label
@export var x_vector_info: Label

func _ready() -> void:
	y_vector_info = %YVectorInfo
	x_vector_info = %XVectorInfo

func _on_airship_air_changed(new_value: float) -> void:
	if y_vector_info:
		y_vector_info.text = str(snapped(new_value, 0.01)) + " m/s"


func _on_airship_thrust_changed(new_thrust: float) -> void:
	if x_vector_info:
		x_vector_info.text = str(snapped(new_thrust, 0.01)) + " m/s"

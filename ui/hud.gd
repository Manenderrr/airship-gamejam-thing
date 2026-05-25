class_name HUD
extends Control

@export var y_vector_info: Label
@export var x_vector_info: Label

@export var mission_number_info: Label
@export var prod1_info: Label
@export var prod2_info: Label
@export var prod3_info: Label

@export var death_warning: DeathWarning
@export var death_screen: CanvasItem

func _ready() -> void:
	y_vector_info = %YVectorInfo
	x_vector_info = %XVectorInfo

func _on_airship_air_changed(new_value: float) -> void:
	if y_vector_info:
		y_vector_info.text = str(snapped(new_value, 0.01)) + " m/s"

func _on_airship_horizontal_speed_changed(new_value: float) -> void:
	if x_vector_info:
		x_vector_info.text = str(snapped(new_value, 0.01)) + " m/s"
func _on_airship_thrust_changed(new_thrust: float) -> void:
	if x_vector_info:
		x_vector_info.text = str(snapped(new_thrust, 0.01)) + " m/s"

func show_death_screen() -> void:
	death_screen.show()
func restart_game() -> void:
	SceneManager.start_main_game()
func show_main_menu() -> void:
	SceneManager.start_main_menu()
func quit_game() -> void:
	SceneManager.quit_game()


func _on_ports_mission_added(prod_name1: String, prod1: int, prod_name2: String, prod2: int, prod_name3: String, prod3: int, mission_number: int) -> void:
	mission_number_info.text = "Station number: " + str(mission_number + 1)
	prod1_info.text = "Resource 1: " + prod_name1 + " " + str(prod1)
	prod2_info.text = "Resource 2: " + prod_name2 + " " + str(prod2)
	prod3_info.text = "Resource 3: " + prod_name3 + " " + str(prod3)

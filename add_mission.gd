extends Node

@onready var airship: RigidBody3D = %airship
@export var ports: Array[StaticBody3D] = []
var items_amount: float
var port_number: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_mission():
	while airship.mission_number == -1:
		airship.mission_number = randi_range(0, ports.size() - 1)
		if airship.mission_number == port_number:
			airship.mission_number = -1

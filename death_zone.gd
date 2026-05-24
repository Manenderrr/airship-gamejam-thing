extends Area3D

@export var ui: DeathWarning

@export var is_too_low: bool = true

func too_low(body: Node3D):
	if body.is_in_group("Player"): ui.initiate_too_low()
func too_high(body: Node3D):
	if body.is_in_group("Player"): ui.initiate_too_high()
func _ready() -> void:
	assert(ui, "hud is not set")

	if is_too_low: body_entered.connect(too_low)
	else: body_entered.connect(too_high)

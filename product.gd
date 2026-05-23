extends Resource
class_name Product

@export var name: String = ""
@export var size: float = 0:
	set(value):
		size = value
		update_weight()
@export var density: float = 0:
	set(value):
			density = value
			update_weight()
@export var amount: int = 0
var weight: float = 0

func update_weight() -> void:
	weight = density * size

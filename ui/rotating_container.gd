@tool
## th beer
class_name RotatingContainer
extends Container

## The angle to rotate children by.
@export_range(-360.0, 360.0, 0.1, "radians_as_degrees") var child_rotation: float = PI / 2:
	set(value):
		child_rotation = value
		queue_sort()

func _notification(what: int) -> void:
	if what != NOTIFICATION_SORT_CHILDREN: return
	for c in get_children():
		if c is Control:
			fit_child_in_rect(c, Rect2(Vector2(), size))
			c.pivot_offset_ratio = Vector2(0.5, 0.5)
			c.rotation = child_rotation

class_name RotatingContainer
extends Container

func _notification(what: int) -> void:
	if what != NOTIFICATION_SORT_CHILDREN: return
	for c in get_children():
		fit_child_in_rect(c, Rect2(Vector2(), size))

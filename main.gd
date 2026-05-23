extends Node

## Triggered when the game is supposed to be paused.
signal on_pause

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("pause"):
		on_pause.emit()
		get_viewport().set_input_as_handled()

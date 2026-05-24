extends Control

func pause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	show()

func unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	hide()

func main_menu() -> void:
	unpause()
	SceneManager.start_main_menu()

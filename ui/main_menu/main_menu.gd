extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func quit_game() -> void:
	SceneManager.quit_game()

func play() -> void:
	SceneManager.start_main_game()

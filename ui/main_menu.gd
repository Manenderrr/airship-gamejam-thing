extends Control

func quit_game() -> void:
	get_tree().quit()

func play() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_game)

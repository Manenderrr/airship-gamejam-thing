extends Node

@export var main_menu: PackedScene
@export var main_game: PackedScene

func quit_game() -> void:
	get_tree().quit()

func start_main_game() -> void:
	get_tree().change_scene_to_packed(main_game)

func start_main_menu() -> void:
	get_tree().change_scene_to_packed(main_menu)

extends Node

@export var main_menu: PackedScene
@export var main_game: PackedScene

func _ready() -> void:
	assert(main_menu, "main_menu is not set")
	assert(main_game, "main_game is not set")

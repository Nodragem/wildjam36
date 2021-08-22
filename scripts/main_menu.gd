extends Control

export (Resource) var game_options
var main_scene

func _ready():
	game_options.difficulty = $Control/OptionButton.selected
	main_scene = preload("res://scenes/main.tscn")


func _on_TextureButton_button_down():
	get_tree().change_scene_to(main_scene)


func _on_OptionButton_item_selected(index):
	game_options.difficulty = index

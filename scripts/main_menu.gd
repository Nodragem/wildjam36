extends Control

export (Resource) var game_options

func _ready():
	pass


func _on_TextureButton_button_down():
	get_tree().change_scene("res://scenes/main.tscn")


func _on_OptionButton_item_selected(index):
	game_options.difficulty = index

extends Control


func _ready():
	pass


func _on_TextureButton_button_down():
	get_tree().change_scene("res://scenes/main.tscn")

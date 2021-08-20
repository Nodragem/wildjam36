extends HBoxContainer

export (Resource) var tracked_value
export var signal_name = ""
onready var progress_bar = $TextureProgress
onready var progress_text = $TextureProgress/Number 

func _ready():
	if tracked_value:
		tracked_value.connect(signal_name, self, "_on_value_changed")

func _on_value_changed(value):
	progress_bar.value = value
	progress_text.text = str(value)


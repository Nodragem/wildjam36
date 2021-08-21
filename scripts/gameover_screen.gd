extends Panel

export (Resource) var tracked_value
export var signal_name = ""
onready var animation = $AnimationPlayer

func _ready():
	if tracked_value:
		tracked_value.connect(signal_name, self, "_on_game_over")

func _on_game_over():
	animation.play("FadeIn")


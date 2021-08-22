extends Label

export (Resource) var game_options

func _ready():
	if game_options:
		text = "Mode: "+ str(GameOptions.DIFFICULTY_MODE.keys()[game_options.difficulty])

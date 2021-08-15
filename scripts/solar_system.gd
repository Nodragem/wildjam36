extends Spatial

var planets = []
var current_planet = 0

func _ready():
	yield(get_tree().root, "ready")
	planets = []
	for child in get_children():
		if child is Planet:
			planets.append(child)
			child.connect("conquered", self, "on_planet_conquered")
	planets[current_planet].current_state = Planet.State.IN_PROGRESS 

func on_planet_conquered():
	current_planet += 1
	if current_planet >= planets.size():
		# the sun was taked!
		print("GAME OVER!")
	else:
		planets[current_planet].current_state = Planet.State.IN_PROGRESS

extends Spatial

export (Resource) var plant_status
var planets = []
var current_planet = 0
signal planet_changed

func _ready():
	yield(owner, "ready")
	plant_status.reset()
	planets = []
	for child in get_children():
		if child is Planet:
			planets.append(child)
			child.connect("conquered", self, "on_planet_conquered")
			child.connect("spike_planted", self, "on_planted_spike")
	planets[current_planet].current_state = Planet.State.IN_PROGRESS 

func on_planet_conquered():
	current_planet += 1
	if current_planet >= planets.size():
		# the sun was taked!
		print("GAME OVER!")
	else:
		planets[current_planet].current_state = Planet.State.IN_PROGRESS
		emit_signal("planet_changed", planets[current_planet].get_path())

func on_planted_spike():
	plant_status.make_progress(1)

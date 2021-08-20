extends Resource
class_name PlantStatus

signal progress_changed
signal health_changed

export (int) var health_max_value
export (int) var progress_max_value

var health_value = 0
var progress_value = 0

func reset():
	health_value = health_max_value
	progress_value = 0
	emit_signal("health_changed", health_value)
	emit_signal("progress_changed", progress_value)


func take_damage(amount):
	health_value = max(0, health_value - amount)
	emit_signal("health_changed", health_value)

func make_progress(amount):
	progress_value = max(0, progress_value + amount)
	emit_signal("progress_changed", progress_value)

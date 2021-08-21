extends Spatial


export (NodePath) var target_path = null
var target
var lerp_speed = 4.0

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(delta):
	if !target:
		return
	var nb = global_transform.looking_at(target.global_transform.origin, target.transform.basis.y)
	global_transform = global_transform.interpolate_with(nb, lerp_speed * delta)


func _on_solar_system_planet_changed(new_target_path):
	print("target changed to "+new_target_path)
	target = get_node(new_target_path)
	

tool
extends MultiMeshInstance

export var radius := 12.0

func _enter_tree():
	connect("visibility_changed", self, "_on_WindGrass_visibility_changed")


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var theta := 0
	var phi := 0
	var center: Vector3 = global_transform.origin

	for i in multimesh.instance_count:
		
		var spike_transform:Transform = Transform()
		var pos:Vector3 = Vector3();
		
		theta = rng.randf_range(-2*PI, 2*PI)
		phi = rng.randf_range(-2*PI, 2*PI)
		pos.x = center.x + radius * cos(theta)
		pos.y = center.y + radius * sin(theta)
		pos.z = center.z
		pos = center + (pos - center).rotated(Vector3.UP, phi)
		
		spike_transform.origin = center
		spike_transform = spike_transform.looking_at(pos, Vector3.RIGHT)
		spike_transform.origin = pos
#		pos.direction_to()
#		

		multimesh.set_instance_transform(i, spike_transform)


func _on_WindGrass_visibility_changed():
	if visible:
		_ready()


func _process(delta):
	pass
#	material_override.set_shader_param(
#		"character_position", get_node(character_path).global_transform.origin
#	)


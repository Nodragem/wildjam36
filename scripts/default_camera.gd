extends Spatial

var invert_y = false
var invert_x = false
var mouse_control = false
var mouse_sensitivity = 0.005
var camera
var inner_gymbal

func _ready():
	camera = get_viewport().get_camera()
	if not camera:
		inner_gymbal= Spatial.new()
		add_child(inner_gymbal)
		inner_gymbal.owner = owner
		
		camera = Camera.new()
		camera.current = true
		inner_gymbal.add_child(camera)
		camera.owner = owner
		camera.transform.origin = Vector3(0,0,1000)
		
		camera.global_transform = camera.global_transform.looking_at(-Vector3.UP, Vector3.UP)
		camera.far = 3000
	else:
		camera = null


func _unhandled_input(event):
	if not camera:
		return
	if event is InputEventMouseButton:
		print(event.as_text())
		if event.button_index == BUTTON_LEFT:
			mouse_control = event.pressed
			
	if event is InputEventMouseMotion and mouse_control:
		if event.relative.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var dir = 1 if invert_y else -1
			inner_gymbal.rotate_object_local(Vector3.RIGHT, dir * event.relative.y * mouse_sensitivity)
		


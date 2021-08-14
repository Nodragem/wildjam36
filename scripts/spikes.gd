tool
extends MeshInstance

export var radius := 1.0
onready var multimesh = $MultiMeshInstance.multimesh
onready var walking_head = $WalkingHead
onready var timer = $Timer
var current_id=0
var buffer_transform = Transform()

func _ready() -> void:
	pass


func _process(_delta):
	if not multimesh or current_id >= multimesh.instance_count:
		return
	
	if timer.time_left <= rand_range(0, 1):
		timer.start()
		buffer_transform = walking_head.transform
		buffer_transform = buffer_transform.scaled(Vector3.ONE)
		multimesh.set_instance_transform(current_id, buffer_transform)
		current_id += 1
		multimesh.visible_instance_count = current_id 


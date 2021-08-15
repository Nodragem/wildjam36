tool
extends MeshInstance
class_name Planet

export var radius := 1.0
export(Resource) var resource

onready var multimesh = $MultiMeshInstance.multimesh
onready var walking_head = $WalkingHead
onready var timer = $Timer
var current_id=0
var buffer_transform = Transform()
enum State {FRESH, IN_PROGRESS, CONQUERED, FREED}
export (State) var current_state setget set_state, get_state
signal conquered


func _ready():
	self.current_state = State.FRESH
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = 256
	multimesh.visible_instance_count = 0
	multimesh.mesh = resource
	$MultiMeshInstance.multimesh = multimesh
	
	


func _process(_delta):
	if not multimesh or current_id >= multimesh.instance_count:
		return
	
	if current_state != State.IN_PROGRESS:
		return
	
	if timer.time_left <= rand_range(0, 1):
		timer.start()
		buffer_transform = walking_head.transform
		buffer_transform = buffer_transform.scaled(Vector3.ONE)
		multimesh.set_instance_transform(current_id, buffer_transform)
		current_id += 1
		multimesh.visible_instance_count = current_id
		if current_id == multimesh.instance_count:
			self.current_state = State.CONQUERED

func set_state(state):
	# NOTE: the export var makes Godot call set_state before the _ready() function,
	# so our way to avoid it is to check if null
	if state == null or walking_head == null or multimesh == null:
		return
	
	if state == State.CONQUERED:
		walking_head.set_visible(false)
		emit_signal("conquered")
	elif state == State.FREED:
		walking_head.set_visible(false)
		multimesh.visible_instance_count = 0
	elif state == State.FRESH:
		walking_head.set_visible(false)
		multimesh.visible_instance_count = 0
	elif state == State.IN_PROGRESS:
		walking_head.set_visible(true)
	
	current_state = state
	

func get_state():
	return current_state

extends MeshInstance

tool

export(NodePath) var pathMaskObject
var maskObject: MultiMeshInstance

var position: Vector3 = Vector3()
var phi: float = 0
var theta: float = 0
var radius: float = 1.0

var velocity: Vector2 = Vector2()
var steering: Vector2 = Vector2()
var wander_angle = 0
export var max_speed: float = 2
export var circle_distance = 0.5
export var circle_radius = 1
export var angle_change = 0


func _ready():
	maskObject = get_node(pathMaskObject)
	
func _process(_delta):
	maskObject.get_material_override().set_shader_param("mask_center", global_transform.origin)
	
	steering = wander()
	velocity = (velocity + steering).clamped(max_speed)
	phi = phi + velocity.x
	theta = theta + velocity.y 
	
	position.x = radius * cos(phi) * sin(theta)
	position.y = radius * sin(phi) * sin(theta)
	position.z = radius * cos(theta)
	
	transform.origin = position


func wander() -> Vector2: 
	# Calculate the circle center
	var circle_center: Vector2 = circle_distance*velocity.normalized();

	# Calculate the displacement force
	var displacement: Vector2 = Vector2(0, -circle_radius);
	
	# Randomly change the vector direction
	# by making it change its current angle
	displacement = set_angle(displacement, wander_angle);
	
	# Change wanderAngle just a bit, so it
	# won't have the same value in the
	# next game frame.
	wander_angle += rand_range(-angle_change, angle_change);
	
	# Finally calculate and return the wander force
	var wander_force :Vector2 = circle_center + displacement;
	return wander_force;

 
func set_angle(vector: Vector2, value:float) -> Vector2:
   var length: float = vector.length()
   vector.x = cos(value) * length
   vector.y = sin(value) * length
   return vector
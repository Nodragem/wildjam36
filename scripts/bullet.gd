extends Area

var speed = 150
var damage = 1

func _physics_process(delta):
	transform.origin += -transform.basis.z * speed * delta


func _on_Timer_timeout():
	queue_free()


func _on_bullet_body_entered(body):
	queue_free()


func _on_bullet_area_entered(area):
	queue_free()

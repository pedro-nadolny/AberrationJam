extends CSGMesh3D

@export var angular_speed = Vector3(PI / 4, PI, PI / 2)
var numberOfEnemies = 1

func _physics_process(delta):
	if numberOfEnemies < 1:
		return
		
	var rot_delta = angular_speed * delta
	rotate_object_local(Vector3(1,0,0), angular_speed.x * delta)
	rotate_object_local(Vector3(0,1,0), angular_speed.y * delta)
	rotate_object_local(Vector3(0,0,1), angular_speed.z * delta)

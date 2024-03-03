extends Node2D

func _physics_process(delta):
	if %Player.position.y > position.y:
		%Spawn.respawn()

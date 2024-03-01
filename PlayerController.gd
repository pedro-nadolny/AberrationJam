extends CharacterBody2D

var is_dashing: bool = false
var gravity = 700

func _physics_process(delta):
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
		
	move_and_slide()

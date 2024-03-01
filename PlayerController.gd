extends CharacterBody2D

const gravity = 1500
const max_horizontal_speed = 300
const max_horizontal_acc = 1000
const horizontal_dumping = 300
const min_speed = 10
const jump_force = 550

var max_jumps = 2
var jumps_available = 0

var is_dashing: bool = false
var max_dashes = 1
var dashes_available = 0

func _physics_process(delta):
	apply_gravity(delta)
	horizontal_input(delta)
	jump_input(delta)
		
	move_and_slide()

func apply_gravity(delta):
	if is_on_floor() or is_dashing:
		return
	
	velocity.y += gravity * delta
		
func horizontal_input(delta):
	var input = Input.get_axis("move_left", "move_right")
	var acc = input * max_horizontal_acc
	velocity.x += acc * delta
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, pow(0.5, horizontal_dumping * delta))
		
	velocity.x = clampf(velocity.x , -max_horizontal_speed, max_horizontal_speed)
	
	if abs(velocity.x) < 5:
		velocity.x = 0
	
func jump_input(delta):
	if is_on_floor():
		jumps_available = max_jumps
	
	if not Input.is_action_just_pressed("jump") or jumps_available < 1:
		return
		
	jumps_available -= 1
	velocity.y = -jump_force
	
func dash_input(delta):
	if dashes_available == 0:
		return
		
	velocity.x += signf(velocity.x)
	

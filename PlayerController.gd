extends CharacterBody2D

const gravity = 1500
const max_horizontal_acc = 1000
const horizontal_dumping = 1.5
const min_speed = 10
const jump_force = 600

var max_jumps = 2
var jumps_available = 0

var dash_cooldown = 0
var dash_float = 0
var dash_force = 650
var last_input_sign = 1


func _physics_process(delta):
	var input = Input.get_axis("move_left", "move_right")
	
	if not is_zero_approx(input):
		last_input_sign = sign(input)
	
	apply_gravity(delta)
	horizontal_input(delta, input)
	jump_input(delta)
	dash_input(delta, input)
		
	move_and_slide()	

func apply_gravity(delta):
	if is_on_floor() or dash_float < 0:
		return
	
	velocity.y += gravity * delta
		
func horizontal_input(delta, input):
	var acc = input * max_horizontal_acc
	
	if sign(input) != sign(velocity.x):
		acc *= 3
		
	if abs(velocity.x) < 30:
		acc *= 3
	
	velocity.x += acc * delta
	velocity.x *= (1 - horizontal_dumping * delta)
	
	if abs(velocity.x) < 5:
		velocity.x = 0
	
	$Mesh.scale.x = move_toward($Mesh.scale.x, 1, delta * 10)
	$Mesh.scale.y = move_toward($Mesh.scale.y, 1, delta * 10)
	$Mesh.position.x = move_toward($Mesh.position.x, 0, delta * 50)
	$Mesh.position.y = move_toward($Mesh.position.y, 0, delta * 50)
	
	
func jump_input(delta):
	if is_on_floor():
		jumps_available = max_jumps
	
	if not Input.is_action_just_pressed("jump") or jumps_available < 1:
		return
		
	jumps_available -= 1
	velocity.y = -jump_force
	$Mesh.scale = Vector2(0.7, 1.3)
	$Mesh.position = Vector2(0, -15)
	
func dash_input(delta, input):	
	dash_cooldown = min(0, dash_cooldown + delta)
	dash_float = min(0, dash_float + delta)
	
	if not Input.is_action_just_pressed("dash") or dash_cooldown < 0:
		return
		
	dash_float = -0.25
	dash_cooldown = -0.5
	velocity.x += last_input_sign * dash_force
	velocity.y = 0
	$Mesh.scale = Vector2(1.7, 0.4)
	$Mesh.position = Vector2(30, 8)

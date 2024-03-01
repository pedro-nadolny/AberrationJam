extends CharacterBody2D

const gravity = 1500
const max_horizontal_acc = 1000
const horizontal_dumping = 300
const min_speed = 10
const jump_force = 550

var max_jumps = 2
var jumps_available = 0

var max_dashes = 1
var dashes_available = 0
var dash_timer = 0
var dash_force = 800
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
	if is_on_floor():
		return
	
	velocity.y += gravity * delta
		
func horizontal_input(delta, input):
	var acc = input * max_horizontal_acc
	velocity.x += acc * delta
	velocity.x = lerp(velocity.x, 0.0, pow(0.5, horizontal_dumping * delta))	
	
	if abs(velocity.x) < 5:
		velocity.x = 0
	
func jump_input(delta):
	if is_on_floor():
		jumps_available = max_jumps
	
	if not Input.is_action_just_pressed("jump") or jumps_available < 1:
		return
		
	jumps_available -= 1
	velocity.y = -jump_force
	print_debug("jump")
	
func dash_input(delta, input):
	if is_on_floor():
		dashes_available = max_dashes
	
	dash_timer = min(0, dash_timer + delta)
	
	if not Input.is_action_just_pressed("dash") or dashes_available < 1 or dash_timer < 0:
		return
		
	dashes_available -= 1
	dash_timer = -0.5
	velocity.x += last_input_sign * dash_force
	print_debug("dash")

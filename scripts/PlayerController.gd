extends CharacterBody2D

const gravity = 750
const max_horizontal_acc = 500
const horizontal_dumping = 1.75
const dumping_multiplier_without_input = 3
const min_speed = 5
const jump_force = 300
const max_jumps = 2
const dash_force = 400
const max_y_speed = 1000

var jumps_available = 0
var dash_cooldown = 0
var dash_float = 0
var last_input_sign = 1
var input = 0

func _physics_process(delta):
	input = Input.get_axis("move_left", "move_right")
	
	if not is_zero_approx(input):
		last_input_sign = sign(input)
	
	apply_gravity(delta)
	horizontal_input(delta, input)
	jump_input()
	dash_input(delta)
	move_and_slide()
	
	%Sprite2D.update_animations(
		last_input_sign, 
		is_zero_approx(input), 
		is_zero_approx(velocity.x), 
		is_on_floor(), 
		is_on_wall(), 
		dash_float < 0
	)

func apply_gravity(delta):
	if is_on_floor() or dash_float < 0:
		return
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_y_speed)
		
func horizontal_input(delta, input):
	var acc = input * max_horizontal_acc
	
	if sign(input) != sign(velocity.x):
		acc *= 3
		
	if abs(velocity.x) < 30:
		acc *= 3
	
	velocity.x += acc * delta
	
	var dumping_amount = horizontal_dumping * delta
	
	if is_zero_approx(input):
		dumping_amount *= dumping_multiplier_without_input

	velocity.x *= 1 - dumping_amount
	
	if abs(velocity.x) < 5:
		velocity.x = 0
	
	$Sprite2D.scale.x = move_toward($Sprite2D.scale.x, last_input_sign, delta * 50)
	$Sprite2D.scale.y = move_toward($Sprite2D.scale.y, 1, delta * 50)
	
func jump_input():
	if is_on_floor():
		jumps_available = max_jumps
	
	if not Input.is_action_just_pressed("jump") or jumps_available < 1:
		return
		 
	jumps_available -= 1
	velocity.y = -jump_force
	$Sprite2D.scale = Vector2(0.7, 1.3)
	
func dash_input(delta):	
	dash_cooldown = min(0, dash_cooldown + delta)
	dash_float = min(0, dash_float + delta)
	
	if not Input.is_action_just_pressed("dash") or dash_cooldown < 0:
		return
		
	dash_float = -0.25
	dash_cooldown = -0.5
	velocity.x += last_input_sign * dash_force
	velocity.y = 0

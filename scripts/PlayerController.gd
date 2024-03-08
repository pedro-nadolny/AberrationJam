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
const jump_buffer_time = 0.15

var jumps_available = 0
var dash_cooldown = 0
var dash_float = 0
var last_input_sign = 1
var input = 0
var jump_buffer = 0.0
var was_on_floor = false

signal died

func _physics_process(delta):
	input = Input.get_axis("move_left", "move_right")
	
	if not is_zero_approx(input):
		last_input_sign = sign(input)
	disable_mode
	fall(delta)
	walk(delta)
	jump(delta)
	dash(delta)
	
	was_on_floor = is_on_floor()
	move_and_slide()
	
	var collision := get_last_slide_collision()
	
	if collision:
		collision(collision.get_collider())
	
	%Sprite2D.update_animations(
		last_input_sign, 
		is_zero_approx(input), 
		is_zero_approx(velocity.x), 
		is_on_floor(), 
		is_on_wall(), 
		dash_float > 0
	)

func fall(delta):
	if is_on_floor() or dash_float > 0:
		return
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_y_speed)
		
func walk(delta):
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
	
func jump(delta):	
	jump_buffer = move_toward(jump_buffer, 0, delta)
	
	if is_on_floor():
		jumps_available = max_jumps
		
	if !was_on_floor && is_on_floor() && jump_buffer > 0:
		perform_jump()
		printt("jump buffer")
		return
	
	if not Input.is_action_just_pressed("jump"):
		return
		 
	if jumps_available < 1:
		jump_buffer = jump_buffer_time
		return
	
	perform_jump()
	
func perform_jump():
	jumps_available -= 1
	velocity.y = -jump_force
	
func dash(delta):	
	dash_cooldown = move_toward(dash_cooldown, 0, delta)
	dash_float = move_toward(dash_float, 0, delta)
	
	if not Input.is_action_just_pressed("dash") or dash_cooldown > 0:
		return
		
	dash_float = 0.25
	dash_cooldown = 0.5
	velocity.x += last_input_sign * dash_force
	velocity.y = 0
	
func collision(collider):
	if !collider.is_in_group("aberration"):
		return
		
	if dash_float > 0:
		collider.queue_free()
		return
		
	died.emit()

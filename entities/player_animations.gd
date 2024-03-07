extends Node2D

func update_animations(direction, is_idle, is_stoped_x, is_on_floor):
	var idle_animation = is_stoped_x && is_on_floor
	var run_animation = !is_idle && is_on_floor
	var default_animation = !idle_animation && ! run_animation
	
	%AnimationTree["parameters/conditions/idle"] = idle_animation
	%AnimationTree["parameters/conditions/moving"] = run_animation
	%AnimationTree["parameters/conditions/default"] = default_animation
	scale.x = direction

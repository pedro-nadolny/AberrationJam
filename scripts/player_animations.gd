extends Node2D

func update_animations(direction, is_idle, is_stoped_x, is_on_floor, is_on_wall, is_dashing):
	var idle_animation = is_stoped_x && is_on_floor && !is_dashing
	var run_animation = !is_idle && is_on_floor && !is_dashing
	var dash_animation = is_dashing || (!is_on_floor && !is_idle) 
	
	var no_animations = !idle_animation && ! run_animation && !dash_animation
	var default_animation = no_animations || (is_on_wall && !is_dashing)
	
	%AnimationTree["parameters/conditions/idle"] = !default_animation && idle_animation
	%AnimationTree["parameters/conditions/run"] = !default_animation && run_animation
	%AnimationTree["parameters/conditions/dashing"] = !default_animation && dash_animation
	%AnimationTree["parameters/conditions/default"] = default_animation

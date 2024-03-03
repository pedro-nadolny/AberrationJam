extends Node2D

func _ready():
	respawn()

func respawn():
	%Player.position.y = position.y
	%Player.velocity = Vector2.ZERO
	%Player.jumps_available = 0
	%Player.dash_cooldown = -1
	
	%TileMap.position.x = -position.x

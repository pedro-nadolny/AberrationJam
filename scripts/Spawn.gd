extends Node2D

func _ready():
	respawn()

func respawn():
	%Player.velocity = Vector2.ZERO
	%Player.jumps_available = 0
	%Player.dash_cooldown = -1
	%Player.position = position

func _on_player_died():
	respawn()

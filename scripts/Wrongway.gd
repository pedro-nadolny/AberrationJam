@tool
extends Sprite2D

func _ready():
	texture = $SubViewport.get_texture()

extends Sprite2D

@onready var viewport = $Viewport

func _process(delta):
	texture = viewport.get_texture()

@tool
extends StaticBody2D

func _ready():
	if Engine.is_editor_hint():
		return
	
	var collider := CollisionPolygon2D.new()
	collider.polygon = $Polygon2D.polygon
	add_child(collider)

extends Area2D


var targeting_enemy: Node2D



func _on_Area2D_area_entered(area: Area2D) -> void:
	print("sword has collided")
	if (area.has_method("hurt")):
		area.hurt()



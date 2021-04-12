extends Area2D

onready var enemies_list = get_tree().get_nodes_in_group("Enemy")


func _on_Sword_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.hurt()

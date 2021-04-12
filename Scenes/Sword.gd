extends Area2D

onready var enemies_list = get_tree().get_nodes_in_group("Enemy")


func _on_Sword_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent() 
	if enemy is Enemy:
		enemy.hurt(1)
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Attack"):
		print("being pressed")
		monitoring = !monitoring

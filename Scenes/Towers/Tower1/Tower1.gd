extends Node2D

const bullet = preload("res://Scenes/Bullet.tscn")

var targeting_enemy: Node2D

func _process(delta):
	if targeting_enemy:
		rotation = global_position.direction_to(targeting_enemy.global_position).angle()

func _on_enemy_detected(enemy: Node) -> void:
	print("enemy detected")
	targeting_enemy = enemy
	$Timer.connect("timeout", self, "shoot_enemy", [enemy])
	$Timer.start()

func shoot_enemy(enemy: Node2D):
	var b = bullet.instance()
	get_parent().add_child(b)
	b.global_position = global_position
	b.direction = global_position.direction_to(enemy.global_position).normalized()
	b.rotation = b.direction.angle()

func _on_enemy_exited(area):
	targeting_enemy = null
	$Timer.stop()
	$Timer.disconnect("timeout", self, "shoot_enemy")

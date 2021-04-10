extends Area2D

export (PackedScene) var Bullet
export var speed = 500

var direction: Vector2

func _physics_process(delta):
	position += direction * speed * delta

func _on_enemy_hit(enemy_area: Area2D) -> void:
	var enemy = enemy_area.get_parent()
	if (enemy.has_method("hurt")):
		enemy.hurt()
	queue_free()

class_name BulletTower
extends Tower

export(PackedScene) var Bullet

func _process(_delta):
	pass
	#if target_enemy:
	#	rotation = global_position.direction_to(target_enemy.global_position).angle()

func action():
	# Shoot at the target_enemy
	var b = Bullet.instance()
	b.damage = stats.damage
	get_parent().add_child(b)
	var tower_position = global_position
	b.global_position = tower_position
	b.direction = tower_position.direction_to(target_enemy.global_position).normalized()
	b.rotation = b.direction.angle()

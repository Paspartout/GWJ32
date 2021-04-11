class_name TowerSlower
extends Tower

func action():
	for enemy in enemies_queue:
		enemy.slow(5, 0.5)

extends Node2D

export(PackedScene) var Bullet = preload("res://Scenes/Towers/Tower1/Bullet.tscn")

var targeting_enemy: Node2D

onready var shoot_timer = $Timer

func _ready():
	shoot_timer.connect("timeout", self, "shoot_enemy")

func _process(delta):
	if targeting_enemy:
		rotation = global_position.direction_to(targeting_enemy.global_position).angle()

var enemies_queue: Array

func _on_enemy_detected(enemy: Node) -> void:
	if shoot_timer.is_stopped():
		shoot_timer.start()

	enemies_queue.append(enemy)
	if !enemy.get_parent().is_connected("killed", self, "_on_enemy_killed"):
		enemy.get_parent().connect("killed", self, "_on_enemy_killed", [enemy.get_parent()])
	# TODO: Maybe have to this more often?
	if not targeting_enemy:
		targeting_enemy = enemies_queue.front()

func _on_enemy_exited(enemy: Node2D):
	enemies_queue.erase(enemy)
	if enemies_queue.size() <= 0:
		shoot_timer.stop()
		targeting_enemy = null
	else:
		targeting_enemy = enemies_queue.front()
		shoot_timer.start()

func _on_enemy_killed(loot, enemy):
	var enemy_index = enemies_queue.find(enemy)
	if enemy_index >= 0:
		enemies_queue.remove(enemy_index)
	if enemy == targeting_enemy:
		targeting_enemy = null
	if not targeting_enemy:
		if enemies_queue.size() > 0:
			targeting_enemy = enemies_queue.front()

func shoot_enemy():
	var b = Bullet.instance()
	get_parent().add_child(b)
	b.global_position = global_position
	b.direction = global_position.direction_to(targeting_enemy.global_position).normalized()
	b.rotation = b.direction.angle()

# Tower class that maintains a list of attackable enemies(enemies_queue)
class_name Tower
extends Node2D

onready var action_timer = $Timer

# The enemy that is currently targeted
var target_enemy: Node2D
# Queue of all enemies that are attackable/in range
var enemies_queue: Array
var stats: TowerStat

func _ready():
	action_timer.connect("timeout", self, "action")
	action_timer.wait_time = 1/stats.action_speed

func init(new_stats: TowerStat):
	stats = new_stats

func action():
	assert("Not implemented?")

func _on_enemy_detected(enemy_area: Area2D) -> void:
	var enemy = enemy_area.get_parent()

	enemies_queue.append(enemy)
	if !enemy.is_connected("killed", self, "_on_enemy_killed"):
		enemy.connect("killed", self, "_on_enemy_killed", [enemy.get_parent()])
	# TODO: Maybe have to this more often?
	if not target_enemy:
		target_enemy = enemies_queue.front()
	if action_timer.is_stopped():
		action_timer.start()
		call_deferred("action")

func _on_enemy_exited(enemy_area: Area2D):
	var enemy = enemy_area.get_parent()

	enemies_queue.erase(enemy)
	if enemies_queue.size() <= 0:
		action_timer.stop()
		target_enemy = null
	else:
		target_enemy = enemies_queue.front()
		if is_instance_valid(action_timer):
			action_timer.autostart = true

func _on_enemy_killed(loot, enemy):
	var enemy_index = enemies_queue.find(enemy)
	if enemy_index >= 0:
		enemies_queue.remove(enemy_index)
	if enemy == target_enemy:
		target_enemy = null
	if not target_enemy:
		if enemies_queue.size() > 0:
			target_enemy = enemies_queue.front()

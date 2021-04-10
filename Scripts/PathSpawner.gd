extends Node2D

signal wave_finished()

var enemy = preload("res://Scenes/Enemies/Enemy.tscn")

onready var enemy_path: Path2D = $EnemyPath
onready var wave_player: AnimationPlayer = $WavePlayer
onready var game: Game = get_tree().root.get_node("Game")
onready var check_timer: Timer = $CheckTimer

export(Array, String) var waves: Array
var current_wave = 0

var wave_in_progress = false
var spawning_in_progress = false

func _ready():
	assert(waves.size() > 0)

func start():
	spawning_in_progress = true
	wave_in_progress = true
	wave_player.play(waves[current_wave])
	wave_player.connect("animation_finished", self, "spawning_stopped")
	
func spawning_stopped(_name):
	spawning_in_progress = false
	check_timer.connect("timeout", self, "check_remaining_enemies")
	check_timer.start()

func check_remaining_enemies():
	var remaining_enemies = get_tree().get_nodes_in_group("enemies").size()
	if remaining_enemies == 0:
		wave_in_progress = false
		emit_signal("wave_finished")
		current_wave += 1
		check_timer.disconnect("timeout", self, "check_remaining_enemies")
		check_timer.stop()

func spawn_enemy():
	var new_enemy: Enemy = enemy.instance()
	new_enemy.connect("killed", self, "loot")
	new_enemy.add_to_group("enemies")
	enemy_path.add_child(new_enemy)
	
func loot(money):
	game.money += money

func _on_spawner_timeout() -> void:
	spawn_enemy()

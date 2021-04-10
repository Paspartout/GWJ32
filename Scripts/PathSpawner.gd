extends Node2D

export var spawn_time = 5
export var enabled: bool = true

var enemy = preload("res://Scenes/Enemies/Enemy.tscn")

onready var enemy_path: Path2D = $EnemyPath
onready var spawn_timer = $Timer

func _ready():
	spawn_timer.connect("timeout", self, "_on_spawner_timeout")
	spawn_timer.wait_time = spawn_time

func start():
	enabled = true
	spawn_enemy()
	spawn_timer.start()

func stop():
	enabled = false
	spawn_timer.stop()

func spawn_enemy():
	var spawner_enemy = enemy.instance()
	enemy_path.add_child(spawner_enemy)

func _on_spawner_timeout() -> void:
	spawn_enemy()

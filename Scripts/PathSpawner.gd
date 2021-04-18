extends Node2D

signal wave_finished()

export(Array, PackedScene)var enemy_scenes = [
	preload("res://Scenes/Enemies/EnemyOrc.tscn"),
	preload("res://Scenes/Enemies/EnemyGoblin.tscn"),
	preload("res://Scenes/Enemies/EnemyOgre.tscn")
]

onready var enemy_path_left: Path2D = $EnemyPathLeft
onready var enemy_path_top: Path2D = $EnemyPathTop
onready var enemy_path_right: Path2D = $EnemyPathRight

onready var wave_player: AnimationPlayer = $WavePlayer
onready var game: Game = get_tree().root.get_node("Game")
onready var check_timer: Timer = $CheckTimer

# TODO: Figure out Ysorting: https://github.com/godotengine/godot/issues/28990
onready var enemies_node: Node2D = $Enemies

var wave_in_progress = false
var spawning_in_progress = false

func _ready():
	wave_player.connect("animation_finished", self, "spawning_stopped")

func start_wave(wave_name: String):
	spawning_in_progress = true
	wave_in_progress = true
	wave_player.play(wave_name)

func spawning_stopped(_name):
	spawning_in_progress = false
	check_timer.connect("timeout", self, "check_remaining_enemies")
	check_timer.start()

func check_remaining_enemies():
	var remaining_enemies = get_tree().get_nodes_in_group("enemies").size()
	if remaining_enemies == 0:
		wave_in_progress = false
		emit_signal("wave_finished")
		check_timer.disconnect("timeout", self, "check_remaining_enemies")
		check_timer.stop()

func spawn_enemy(enemy_scene: PackedScene, path: Path2D):
	var new_enemy: Enemy = enemy_scene.instance()
	new_enemy.connect("killed", self, "loot")
	new_enemy.add_to_group("enemies")
	new_enemy.position = Vector2(-10000, -10000)
	enemies_node.add_child(new_enemy)
	
	var remote_transform: RemoteTransform2D = RemoteTransform2D.new()
	var path_follower: PathFollow2D = PathFollow2D.new()
	path_follower.rotate = false
	remote_transform.remote_path = new_enemy.get_path()
	path_follower.add_child(remote_transform)
	new_enemy.path_follower = path_follower
	
	path.add_child(path_follower)

func spawn_top(enemy_num: int):
	spawn_enemy(enemy_scenes[enemy_num], enemy_path_top)

func spawn_left(enemy_num: int):
	spawn_enemy(enemy_scenes[enemy_num], enemy_path_left)

func spawn_right(enemy_num: int):
	spawn_enemy(enemy_scenes[enemy_num], enemy_path_right)

func loot(money):
	game.money += money

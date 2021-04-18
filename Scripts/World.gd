extends Node2D

onready var spawner = $PathSpawner
onready var objects: YSort = $Objects

export(NodePath) var spawn_point_path
onready var spawn_point: Node2D = get_node(spawn_point_path)

export(NodePath) var damage_area_path
onready var damage_area: Area2D = get_node(damage_area_path)

export(PackedScene) var player_scene

func _ready():
	var player = player_scene.instance()
	player.position = spawn_point.position
	objects.add_child(player)

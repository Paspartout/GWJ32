class_name TowerSlot
extends Node2D

export(Array, PackedScene) var all_towers: Array

# TODO: Other way to reference gui?
onready var tower_menu: TowerMenu = get_tree().root.get_node("Game/HUD/TowerMenu")
onready var tower_button: Button = $BuildTowerButton
onready var tower_click_area: Area2D = $TowerClickArea
onready var built_tower: Node2D = $BuiltTower 

onready var game: Game = get_tree().root.get_node("Game")

var built_tower_stats: TowerStat

func _ready():
	tower_click_area.monitoring = false
	game.connect("enable_tower_building", self, "on_enable_tower_building")

func _on_BuildTowerButton_pressed():
	tower_menu.open_build_menu(self)

# TODO: Rename to build tower
func place_tower(tower_stats: TowerStat):
	built_tower_stats = tower_stats
	game.money -= built_tower_stats.cost
	var new_tower = tower_stats.scene.instance()
	new_tower.init(tower_stats)
	built_tower.add_child(new_tower)
	
	tower_button.visible = false
	tower_click_area.monitoring = true
	game.built_towers += 1

func destroy_tower():
	game.money += built_tower_stats.cost
	built_tower_stats = null
	for tower in built_tower.get_children():
		tower.queue_free()

	tower_button.visible = true
	tower_click_area.monitoring = false
	game.built_towers -= 1

func on_enable_tower_building(enabled):
	tower_button.disabled = !enabled

func _on_TowerClickArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if built_tower_stats == null:
			# TODO: Debug why this is happening
			return
		tower_menu.open_tower_menu(self)

func _on_TowerClickArea_mouse_entered():
	built_tower.modulate = Color(1, 0, 0, 1)

func _on_TowerClickArea_mouse_exited():
	built_tower.modulate = Color(1, 1, 1, 1)

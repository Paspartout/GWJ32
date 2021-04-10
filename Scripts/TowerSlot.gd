class_name TowerSlot
extends Node2D

export(Array, PackedScene) var all_towers: Array

# TODO: Other way to reference gui?
onready var tower_selection = get_tree().root.get_node("Game/HUD/TowerSelection")
onready var tower_button: Button = $BuildTowerButton

func _ready():
	pass

func _on_BuildTowerButton_pressed():
	tower_selection.open(self)
	
func place_tower(tower: TowerStat):
	var built_tower = tower.scene.instance()
	add_child(built_tower)

	tower_button.visible = false
	$Preview.hide()

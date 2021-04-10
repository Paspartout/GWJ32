class_name TowerSlot
extends Node2D

# TODO: Other way to reference gui?
onready var tower_selection = get_tree().root.get_node("Game/HUD/TowerSelection")

onready var tower_button: Button = $BuildTowerButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func on_tower_select(tower):
	print("Place tower " + tower)

func _on_BuildTowerButton_pressed():
	tower_selection.open(self)
	
func place_tower(number: int):
	print("place tower %d" % number)
	$Preview.visible = true
	tower_button.visible = false

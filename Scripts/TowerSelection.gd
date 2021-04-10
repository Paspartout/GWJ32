class_name TowerSelection
extends Control

export var tower_buttons_path: NodePath
var tower_buttons: Array

signal tower_slected(num)

var tower_costs = [
	100,
	200,
	300
]

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_buttons = get_node(tower_buttons_path).get_children()
	visible = false
	var tower_num = 0
	for tower_button in tower_buttons:
		tower_button.connect("pressed", self, "tower_selected", [tower_num])
		tower_button.text = "Tower %d - Cost: %d" % [tower_num, tower_costs[tower_num]]
		tower_num += 1

func tower_selected(number: int):
	visible = false
	emit_signal("tower_slected", number)
	
func open(slot):
	visible = true
	self.connect("tower_slected", slot, "place_tower", [], CONNECT_ONESHOT)

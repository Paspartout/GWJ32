class_name TowerSelection
extends Control

export var tower_buttons_path: NodePath
onready var tower_button_container: Container = get_node(tower_buttons_path)

onready var game: Game = get_tree().root.get_node("Game")

signal tower_selected(tower)
var tower_button_stats: Dictionary
var selected_slot

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	tower_button_stats = create_buttons(Towers.all_towers)
	for tb in tower_button_stats.values():
		tower_button_container.add_child(tb)
	update_buttons()

func create_buttons(tower_stats: Array) -> Dictionary:
	var created_buttons = {}
	for tower in tower_stats:
		var tower_button: Button = Button.new()
		tower_button.text = "%s - Cost: %d" % [tower.name, tower.cost]
		tower_button.icon = tower.icon
		tower_button.connect("pressed", self, "tower_selected", [tower])
		created_buttons[tower] = tower_button
	return created_buttons

func update_buttons():
	for stat in tower_button_stats.keys():
		var button = tower_button_stats[stat]
		button.disabled = stat.cost > game.money

func tower_selected(tower: TowerStat):
	game.money -= tower.cost
	visible = false
	emit_signal("tower_selected", tower)

func open(slot):
	if visible:
		return
	update_buttons()
	visible = true
	selected_slot = slot
	self.connect("tower_selected", slot, "place_tower", [], CONNECT_ONESHOT)

func _on_CancelButton_pressed():
	visible = false
	self.disconnect("tower_selected", selected_slot, "place_tower")
	selected_slot = null

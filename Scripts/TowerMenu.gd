class_name TowerMenu
extends Control

export var tower_buttons_path: NodePath
export var tower_stats_path: NodePath

onready var tower_button_container: Container = get_node(tower_buttons_path)
onready var tower_stats_container: Container = get_node(tower_stats_path)

onready var upgrade_button: Button = $Layout/ActionRow/Upgrade
onready var destroy_button: Button = $Layout/ActionRow/Destroy
onready var cancel_button: Button = $Layout/ActionRow/Cancel

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
	update_build_buttons()

func create_buttons(tower_stats: Array) -> Dictionary:
	var created_buttons = {}
	for tower in tower_stats:
		var tower_button: Button = Button.new()
		tower_button.text = "%s - Cost: %d" % [tower.name, tower.cost]
		tower_button.icon = tower.icon
		tower_button.connect("pressed", self, "tower_button_pressed", [tower])
		tower_button.hint_tooltip = tower.description
		created_buttons[tower] = tower_button
	return created_buttons

func update_build_buttons():
	for stat in tower_button_stats.keys():
		var button = tower_button_stats[stat]
		button.disabled = stat.cost > game.money

func tower_button_pressed(tower: TowerStat):
	emit_signal("tower_selected", tower)
	close()

func update_tower_stats(stats: TowerStat):
	tower_stats_container.get_node("TowerIcon").texture = stats.icon
	tower_stats_container.get_node("TowerName").text = stats.name
	tower_stats_container.get_node("StatsGrid/SpeedValue").text = "%.1f/s" % stats.action_speed
	tower_stats_container.get_node("StatsGrid/DamageValue").text = "%d HP" % stats.damage

func open_tower_menu(slot):
	# Don't reopen if already visible
	if visible:
		return

	update_tower_stats(slot.built_tower_stats)
	
	tower_stats_container.visible = true
	tower_button_container.visible = false
	upgrade_button.disabled = false # TODO: Add upgrade logic
	destroy_button.disabled = false

	selected_slot = slot
	update_build_buttons()
	
	visible = true

func open_build_menu(slot):
	# Don't reopen if already visible
	if visible:
		return

	tower_stats_container.visible = false
	tower_button_container.visible = true
	upgrade_button.disabled = true
	destroy_button.disabled = true

	selected_slot = slot
	update_build_buttons()
	self.connect("tower_selected", slot, "place_tower", [], CONNECT_ONESHOT)
	
	visible = true

func close():
	visible = false
	selected_slot = null

func _on_CancelButton_pressed():
	if self.is_connected("tower_selected", selected_slot, "place_tower"):
		self.disconnect("tower_selected", selected_slot, "place_tower")
	close()

func _on_Upgrade_pressed():
	assert(selected_slot != null)
	selected_slot.upgrade_tower()

func _on_Destroy_pressed():
	assert(selected_slot != null)
	selected_slot.destroy_tower()
	close()


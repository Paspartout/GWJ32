class_name Game
extends Node2D

enum State { Building, Wave }

export(int) var health: int = 5 setget set_health
export(int) var money: int = 1000 setget set_money
var state = State.Building

export var spawner_path: NodePath
export var start_wave_button_path: NodePath
export var ui_animations_path: NodePath

onready var hp_label: Label = $HUD/WaveStats/HBoxContainer/HP
onready var money_label: Label = $HUD/WaveStats/HBoxContainer/Money
onready var spawner = get_node(spawner_path)
onready var start_wave_button: Button = get_node(start_wave_button_path)
onready var ui_animations: AnimationPlayer = get_node(ui_animations_path)

func _ready():
	set_money(money)
	set_health(health)
	start_wave_button.connect("pressed", self, "start_wave")
	spawner.connect("wave_finished", self, "wave_finished")
	spawner.connect("game_finished", self, "game_finished")

func set_health(new_heatlh):
	health = new_heatlh
	hp_label.text = "HP: %d" % health

func set_money(new_money):
	money = new_money
	money_label.text = "Money: %d" % money

func start_wave():
	assert(state == State.Building)
	start_wave_button.text = "Wave in Progress"
	start_wave_button.disabled = true
	start_wave_button.release_focus()
	state = State.Wave
	spawner.start()

func wave_finished():
	start_wave_button.disabled = false
	start_wave_button.text = "Start Wave"
	state = State.Building

func game_finished():
	start_wave_button.disabled = false
	start_wave_button.text = "Restart Game"
	state = State.Building
	ui_animations.play("GameWon")
	start_wave_button.disconnect("pressed", self, "start_wave")
	start_wave_button.connect("pressed", self, "restart_game")

func restart_game():
	get_tree().reload_current_scene()

func _on_DamageArea_area_entered(area):
	print(area.get_parent())
	area.get_parent().queue_free()
	health -= 1
	if health == 0:
		get_tree().change_scene("res://Game Over.tscn")

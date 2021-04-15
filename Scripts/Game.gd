class_name Game
extends Node2D


enum State { Building, Wave }

signal enable_tower_building(enabled)

export(int) var health: int = 5 setget set_health
export(int) var money: int = 1000 setget set_money

var built_towers = 0 setget set_built_towers
const MAX_TOWERS = 7
var state = State.Building

export var world_path: NodePath
export var start_wave_button_path: NodePath
export var ui_animations_path: NodePath

onready var hp_label: Label = $HUD/WaveStats/HBoxContainer/HP
onready var money_label: Label = $HUD/WaveStats/HBoxContainer/Money
onready var tower_label: Label = $HUD/WaveStats/HBoxContainer/Towers
onready var world = get_node(world_path)
onready var spawner = world.spawner
onready var damage_area: Area2D = world.damage_area
onready var start_wave_button: Button = get_node(start_wave_button_path)
onready var ui_animations: AnimationPlayer = get_node(ui_animations_path)
onready var audio_player: AudioStreamPlayer = $TreeHurtAudio

const HP_STRING = "HP: %d"
const MONEY_STRING = "Essence: %d"
const TOWERS_STRING = "Towers: %d/%d"

func _ready():
	
	set_money(money)
	set_health(health)
	set_built_towers(built_towers)
	start_wave_button.connect("pressed", self, "start_wave")
	spawner = world.spawner
	spawner.connect("wave_finished", self, "wave_finished")
	spawner.connect("game_finished", self, "game_finished")
	damage_area.connect("area_entered", self, "_on_DamageArea_area_entered")
	
func set_health(new_heatlh):
	health = new_heatlh
	if hp_label:
		hp_label.text = HP_STRING % health

func set_money(new_money):
	money = new_money
	if money_label:
		money_label.text = MONEY_STRING % money

func set_built_towers(new_built_towers):
	built_towers = new_built_towers
	if tower_label:
		tower_label.text = TOWERS_STRING % [built_towers, MAX_TOWERS]
	emit_signal("enable_tower_building", built_towers < MAX_TOWERS)

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
	audio_player.play()
	area.get_parent().queue_free()
	self.health -= 1
	if health == 0:
		print("Game Over")
		# TODO: Redo the game over with proper checkpoints/reloading of wave state

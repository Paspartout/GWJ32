class_name Game
extends Node2D

enum State { Building, Wave }

signal enable_tower_building(enabled)
signal money_changed(new_value)

export(int) var health: int = 5 setget set_health
export(int) var money: int = 0 setget set_money

var money_before_start = 0

var built_towers = 0 setget set_built_towers
const MAX_TOWERS = 7
var state = State.Building

export(Array, String) var waves: Array

export var current_wave: int = 0
export var skip_tutoial: bool = false
export var world_path: NodePath
export var start_wave_button_path: NodePath

onready var hp_label: Label = $HUD/WaveStats/HBoxContainer/HP
onready var money_label: Label = $HUD/WaveStats/HBoxContainer/Money
onready var tower_label: Label = $HUD/WaveStats/HBoxContainer/Towers
onready var dialog_box: DialogBox = $HUD/DialogBox
onready var sfx_player: AudioStreamPlayer = $SfxPlayer

onready var world = get_node(world_path)
onready var spawner = world.spawner
onready var damage_area: Area2D = world.damage_area
onready var start_wave_button: Button = get_node(start_wave_button_path)
onready var audio_player: AudioStreamPlayer = $TreeHurtAudio
onready var tween: Tween = $Tween
onready var music_lpf: AudioEffectLowPassFilter = AudioServer.get_bus_effect(1, 0)
onready var camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]

const HP_STRING = "HP: %d"
const MONEY_STRING = "Essence: %d"
const TOWERS_STRING = "Towers: %d/%d"

func _ready():
	assert(waves.size() > 0)
	set_money(money)
	set_health(health)
	set_built_towers(built_towers)
	start_wave_button.connect("pressed", self, "start_wave")
	spawner = world.spawner
	spawner.connect("wave_finished", self, "wave_finished")
	damage_area.connect("area_entered", self, "_on_DamageArea_area_entered")
	start_wave_button.text = "Start Wave %d" % current_wave
	if not skip_tutoial:
		dialog_box.start_tutorial()

func _input(event):
	if event.is_action_pressed("debug_skip_wave"):
		spawner.skip_wave()

func set_health(new_heatlh):
	health = new_heatlh
	if hp_label:
		hp_label.text = HP_STRING % health

func set_money(new_money):
	money = new_money
	emit_signal("money_changed", money)
	if money_label:
		money_label.text = MONEY_STRING % money

func set_built_towers(new_built_towers):
	built_towers = new_built_towers
	if tower_label:
		tower_label.text = TOWERS_STRING % [built_towers, MAX_TOWERS]
	emit_signal("enable_tower_building", built_towers < MAX_TOWERS)

func start_wave():
	money_before_start = money
	assert(state == State.Building)
	start_wave_button.text = "Wave %d in progress" % current_wave
	start_wave_button.disabled = true
	start_wave_button.release_focus()
	state = State.Wave
	spawner.start_wave(waves[current_wave])
	sfx_player.play()

	AudioServer.set_bus_effect_enabled(1, 0, true)
	tween.interpolate_property(music_lpf, "cutoff_hz", null, 22050, 1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	AudioServer.set_bus_effect_enabled(1, 0, false)

func post_wave(wave: String):
	match wave:
		"wave0_tutorial_meele":
			var dialog = dialog_box.show_multiline([
				"Good work! You got some essence now!",
				"You can use that essence to build towers."
			])
			# This waits for the dialog to be skipped/read
			yield(dialog, "completed")
		"wave1_tutorial_towers":
			var dialog = dialog_box.show_multiline([
				"Nice! Enemies can come from other sides too.",
				"Watch out and place towers wisely.",
				"Also remember you can sell towers.",
			])
			yield(dialog, "completed")
		"wave2":
			var dialog = dialog_box.show_multiline([
				"Good job! But be careful, there are some tanky ogres coming up next wave.",
			])
			yield(dialog, "completed")
		"wave3_introduce_ogres":
			pass # No dialog after wave 4
		"wave4":
			var dialog = dialog_box.show_multiline([
				"Great work! These ogres were though enemies. Tough but slow.",
				"We heard reports that there are goblins are coming our way now.",
				"They seem to be the opposite. Fast but squishy. Be careful!",
				"This might be a good opportunity to build a slow tower if you haven't already tried them.",
			])
			yield(dialog, "completed")
		"wave5_introduce_goblins":
			var dialog = dialog_box.show_multiline([
				"Oh no! There are some more goblins coming our way next wave.",
				"Be prepared with some slow towers on every lane!"
			])
			yield(dialog, "completed")
		"wave6":
			var dialog = dialog_box.show_multiline([
				"Those were some nasty goblins! We almost made it though.",
				"The next wave should be the last one coming but there are three huge ogres coming up.",
				"Preapre to concentrate firepower by moving towers!",
			])
			yield(dialog, "completed")
		"wave7_boss":
			var dialog = dialog_box.show_multiline([
				"Good Job! You saved the forest!"
			])
			yield(dialog, "completed")
		_:
			push_warning("No post_wave action for wave %s" % wave)
	next_wave()

func next_wave():
	current_wave += 1
	start_wave_button.disabled = false
	start_wave_button.text = "Start Wave %d" % current_wave
	state = State.Building
	if current_wave >= waves.size():
		game_finished()

func wave_finished():
	post_wave(waves[current_wave])
	AudioServer.set_bus_effect_enabled(1, 0, true)
	tween.interpolate_property(music_lpf, "cutoff_hz", null, 1000, 1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func game_finished():
	start_wave_button.disabled = false
	start_wave_button.text = "Restart Game"
	state = State.Building
	start_wave_button.disconnect("pressed", self, "start_wave")
	start_wave_button.connect("pressed", self, "restart_game")

func restart_game():
	get_tree().reload_current_scene()

func _on_DamageArea_area_entered(area):
	audio_player.play()
	area.get_parent().queue_free()
	self.health -= 1
	camera.shake(9)
	$"HUD/Fade Effect/AnimationPlayer".play("TreeHurt")
	if health == 0:
		pass

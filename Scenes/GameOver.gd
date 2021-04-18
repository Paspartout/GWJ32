extends Control

onready var game: Game = get_tree().root.get_node("Game")

func _ready():
	hide()

func show():
	game.stop_wave()
	visible = true

func _on_Menu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	get_tree().paused = false
	set_visible(false)

func _on_Restart_pressed():
	game.restart_wave()
	hide()

extends Node2D

var health: int = 3 setget set_health
var money: int = 1000 setget set_money

onready var hp_label = $HUD/Panel/HBoxContainer/HP
onready var money_label = $HUD/Panel/HBoxContainer/Money

func set_health(new_heatlh):
	health = new_heatlh
	hp_label.text = "HP: %d" % health

func set_money(new_money):
	money = new_money
	money_label.text = "Money: %d" % money

func _ready():
	hp_label.text = "HP: %d" % health
	money_label.text = "Money: %d" % money
	
func _on_DamageArea_area_entered(area):
	print(area.get_parent())
	area.get_parent().queue_free()
	#health -= 1
	if health == 0:
		get_tree().change_scene("res://Game Over.tscn")

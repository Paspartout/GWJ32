extends Node2D

var health: int = 3

onready var hp_label = $HUD/Panel/HP

func update_hp():
	hp_label.text = "HP: %d" % health

func _ready():
	update_hp()

func _on_DamageArea_area_entered(area):
	print(area.get_parent())
	area.get_parent().queue_free()
	health -= 1
	update_hp()
	if health == 0:
		get_tree().change_scene("res://Game Over.tscn")


class_name Enemy
extends PathFollow2D

export var hp: int = 3
export var runSpeed: int = 100
export var loot_money: int = 10
 
signal killed(loot)

func _ready():
	add_to_group("enemies")

func _process(delta):
	set_offset(get_offset() + runSpeed * delta)
 
	if(loop == false and get_unit_offset() == 1):
		queue_free()

func hurt(damage: int):
	hp -= damage
	if hp <= 0:
		queue_free()
		emit_signal("killed", loot_money)

class_name Enemy
extends PathFollow2D
export var hp: int = 3
export var default_speed: int = 100
export var loot_money: int = 10
signal killed

onready var timer: Timer = $Timer

var speed = default_speed



func _ready():
	add_to_group("enemies")

func _process(delta):
	set_offset(get_offset() + speed * delta)
 
	if(loop == false and get_unit_offset() == 1):
		queue_free()

func hurt(damage: int):
	hp -= damage
	if hp <= 0:
		queue_free()
		emit_signal("killed", loot_money)

func slow(time: float, multiplier: float):
	speed = default_speed * multiplier
	if !timer.is_connected("timeout", self, "reset_speed"):
		timer.connect("timeout", self, "reset_speed", [], CONNECT_ONESHOT)
	timer.wait_time = time
	timer.start()

func reset_speed():
	speed = default_speed




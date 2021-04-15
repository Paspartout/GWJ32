class_name Enemy
extends PathFollow2D

signal killed(loot)

export var hp: int = 3
export var default_speed: int = 100
export var loot_money: int = 10

onready var slow_timer: Timer = $SlowTimer
onready var sprite: AnimatedSprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer
onready var audio_player = $HurtSoundPlayer

var speed

var last_position: Vector2

func _ready():
	add_to_group("enemies")
	speed = default_speed

func _process(delta):
	var direction = (last_position - position).normalized()
	last_position = position
	
	if direction.y < -0.5:
		sprite.animation = "down"
	elif direction.y > 0.5:
		sprite.animation = "up"
	elif direction.x > 0.5:
		sprite.animation = "left"
	elif direction.x < -0.5:
		sprite.animation = "right"

	set_offset(get_offset() + speed * delta)
 
	if(loop == false and get_unit_offset() == 1):
		queue_free()

func hurt(damage: int):
	audio_player.play()
	animation.play("Hurt")
	hp -= damage
	if hp <= 0:
		yield(audio_player, "finished")
		queue_free()
		emit_signal("killed", loot_money)

func slow(time: float, multiplier: float):
	speed = default_speed * multiplier
	if !slow_timer.is_connected("timeout", self, "reset_speed"):
		slow_timer.connect("timeout", self, "reset_speed", [], CONNECT_ONESHOT)
	slow_timer.wait_time = time
	slow_timer.start()

func reset_speed():
	speed = default_speed



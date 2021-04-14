extends Area2D

export var damage = 1
onready var sprite = $AnimatedSprite

func _ready():
	monitoring = true
	sprite.playing = true

func _on_hit_enemy(enemy_area: Area2D):
	var enemy = enemy_area.get_parent()
	if (enemy.has_method("hurt")):
		enemy.hurt(damage)

func _on_animation_finished():
	queue_free()

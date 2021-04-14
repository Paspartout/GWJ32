extends Area2D

export var speed = 500
export var damage = 1

var direction: Vector2

onready var life_timer = $LifeTimer

export(PackedScene) var explosion_scene: PackedScene

func _ready():
	life_timer.connect("timeout", self, "_on_LifeTimer_timeout")

func _physics_process(delta):
	position += direction * speed * delta

func _on_enemy_hit(enemy_area: Area2D) -> void:
	var explosion = explosion_scene.instance()
	explosion.position = position + (direction * 40)
	get_parent().call_deferred("add_child", explosion)
	queue_free()

func _on_LifeTimer_timeout():
	queue_free()

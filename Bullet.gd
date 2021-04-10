extends Area2D

export (PackedScene) var Bullet
var speed = 100


func _physics_process(delta):
	position += transform.x * speed * delta



func _on_Area2D_area_entered(area: Area2D) -> void:
	queue_free()

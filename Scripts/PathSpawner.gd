extends Path2D
onready var time = $Timer
var timer = 0
export var spawnTime = 5
 
var follower = preload("res://Scenes/CharFollower.tscn")
 
func _on_Timer_timeout() -> void:
		var newFollower = follower.instance()
		add_child(newFollower)

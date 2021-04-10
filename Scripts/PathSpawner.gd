extends Path2D
onready var timer = $Timer

export var spawnTime = 5
export var enabled: bool = true

var follower = preload("res://Scenes/CharFollower.tscn")
 
func _ready():
	if enabled:
		timer.start()
	
func _on_Timer_timeout() -> void:
		var newFollower = follower.instance()
		add_child(newFollower)

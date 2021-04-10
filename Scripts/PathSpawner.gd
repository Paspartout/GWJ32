extends Path2D
onready var timer = $Timer

export var spawnTime = 5
export var enabled: bool = true

var follower = preload("res://Scenes/Enemies/Enemy.tscn")
 
func _ready():
	if enabled:
		spawn_enemy()
		timer.wait_time = spawnTime
		timer.start()

func spawn_enemy():
	var newFollower = follower.instance()
	add_child(newFollower)

func _on_Timer_timeout() -> void:
	spawn_enemy()

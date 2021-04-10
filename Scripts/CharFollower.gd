class_name Enemy
extends PathFollow2D

export var hp = 10
export var runSpeed = 100
 
func _process(delta):
	set_offset(get_offset() + runSpeed * delta)
 
	if(loop == false and get_unit_offset() == 1):
		queue_free()

func hurt():
	hp -= 1
	if hp <= 0:
		queue_free()

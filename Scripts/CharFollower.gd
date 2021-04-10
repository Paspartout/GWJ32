extends PathFollow2D
 
export var runSpeed = 200
 
func _process(delta):
	set_offset(get_offset() + runSpeed * delta)
 
	if(loop == false and get_unit_offset() == 1):
		queue_free()

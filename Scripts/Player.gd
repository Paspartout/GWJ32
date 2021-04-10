extends KinematicBody2D

var speed = 400
var velocity : Vector2 = Vector2()
var facingDirection : Vector2 = Vector2()

func _physics_process(delta):
	
	velocity = Vector2()
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		facingDirection = Vector2(0, -1)
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		facingDirection = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		facingDirection = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		velocity.x += 1
		facingDirection = Vector2(1, 0)
	
	velocity = velocity.normalized()
	
	# move the player
	move_and_slide(velocity * speed)

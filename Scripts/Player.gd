extends KinematicBody2D

var speed = 400
var velocity : Vector2 = Vector2()
var facingDirection : Vector2 = Vector2()
var state_machine

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	velocity = Vector2()
	
	if Input.is_action_pressed("up"):
		state_machine.travel("RunBack")
		velocity.y -= 1
		facingDirection = Vector2(0, -1)
		
	if Input.is_action_pressed("down"):
		state_machine.travel("RunFront")
		velocity.y += 1
		facingDirection = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		state_machine.travel("RunLeft")
		velocity.x -= 1
		facingDirection = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		state_machine.travel("RunRight")
		velocity.x += 1
		facingDirection = Vector2(1, 0)
	
	if velocity.length() == 0:
		state_machine.travel("IdleFront")
		
	
	velocity = velocity.normalized()
	

	move_and_slide(velocity * speed)

extends KinematicBody2D

var speed = 400
var velocity : Vector2 = Vector2()
var facingDirection : Vector2 = Vector2()
var state_machine

var LBP = 0

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	velocity = Vector2()
	

	
	if Input.is_action_pressed("up"):
		LBP = 1
		state_machine.travel("RunBack")
		velocity.y -= 1
		facingDirection = Vector2(0, -1)
		$CPUParticles2D.emitting = true
		
	if Input.is_action_pressed("down"):
		LBP = 2
		$CPUParticles2D.emitting = true
		state_machine.travel("RunFront")
		velocity.y += 1
		facingDirection = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		LBP = 3
		$CPUParticles2D.emitting = true
		state_machine.travel("RunLeft")
		velocity.x -= 1
		facingDirection = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		LBP = 4
		$CPUParticles2D.emitting = true
		state_machine.travel("RunRight")
		velocity.x += 1
		facingDirection = Vector2(1, 0)
	
	if velocity.length() == 0:
		$CPUParticles2D.emitting = false
		if LBP == 1:
			state_machine.travel("IdleBack")
		if LBP == 2:
			state_machine.travel("IdleFront")
		if LBP == 3:
			state_machine.travel("IdleLeft")
		if LBP == 4:
			state_machine.travel("IdleRight")
			
		
	velocity = velocity.normalized()

	move_and_slide(velocity * speed)

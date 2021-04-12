extends KinematicBody2D

export var speed: float = 400
export var damage: int = 1
var velocity : Vector2 = Vector2()
var facingDirection : Vector2 = Vector2()

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")

enum State {
	Move,
	Attack,
}
var state = State.Move

func _ready():
	animation_tree.active = true

func move_state(delta):
	var input_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vec.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if input_vec != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vec)
		animation_tree.set("parameters/Attack/blend_position", input_vec)
		animation_tree.set("parameters/Walk/blend_position", input_vec)
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
	
	if Input.is_action_just_pressed("attack"):
		state = State.Attack
		state_machine.travel("Attack")

	velocity = input_vec.normalized() * speed
	move_and_slide(velocity)

func attack_finished():
	state = State.Move

func attack_state(delta):
	pass

func _physics_process(delta):
	match state:
		State.Move:
			move_state(delta)
		State.Attack:
			attack_state(delta)

func _on_Weapon_hit(area: Area2D):
	var enemy = area.get_parent()
	if enemy.has_method("hurt"):
		enemy.hurt(damage)

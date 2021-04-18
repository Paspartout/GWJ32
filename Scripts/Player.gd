extends KinematicBody2D

export var speed: float = 400
export var damage: int = 1
var velocity : Vector2 = Vector2()
var facingDirection : Vector2 = Vector2()

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var state_machine = animation_tree.get("parameters/playback")
onready var camera = $Camera2D
onready var attack_timer: Timer = $AttackTimer
onready var woosh_sfx: AudioStreamPlayer = $FxPlayer

enum State {
	Move,
	Attack,
}
var state = State.Move

func _ready():
	animation_tree.active = true
	set_process(true);
	attack_timer.connect("timeout", self, "attack")

func _input(event):
	if event.is_action_pressed("attack"):
		attack()
		attack_timer.start()
	elif event.is_action_released("attack"):
		attack_timer.stop()

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

	velocity = input_vec.normalized() * speed
	move_and_slide(velocity)

func attack_finished():
	state = State.Move

func attack_state(delta):
	pass

func attack():
	if state == State.Attack:
		return
	state = State.Attack
	state_machine.travel("Attack")
	woosh_sfx.pitch_scale = rand_range(0.9, 1.3)
	woosh_sfx.play()

func _physics_process(delta):
	match state:
		State.Move:
			move_state(delta)
		State.Attack:
			attack_state(delta)

func _on_Weapon_hit(area: Area2D):
	var enemy = area.get_parent()
	if enemy.has_method("hurt"):
		camera.shake(3)
		enemy.hurt(damage)

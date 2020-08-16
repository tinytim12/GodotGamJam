extends KinematicBody2D

var speed = 64
var velocity = Vector2.ZERO
var jump_speed = -512
var gravity = 32
var ground_normal = Vector2(0, -1)

func _ready():
	pass


func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_speed

	velocity.y += gravity
	
	velocity = move_and_slide(velocity, ground_normal)

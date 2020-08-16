extends KinematicBody2D

var speed = 64
var velocity = Vector2.ZERO
var jump_speed = -384
var gravity = 32
var ground_normal = Vector2(0, -1)
var is_grounded = false
var jump_count = 0
var dir_vector = Vector2(1, 0)


func _ready():
	pass


func _physics_process(delta):
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	
	# now only double jump
	if Input.is_action_just_pressed("ui_up") and jump_count < 2:
		print(str(jump_count) + " - " + str(velocity.y))
		velocity.y = jump_speed
		jump_count += 1

	velocity.y += gravity
	
	velocity = move_and_slide(velocity, ground_normal)
	print(str(jump_count) + " ---- "+ str(velocity.y))
	if is_on_floor():
		is_grounded = true
		jump_count = 0		
	else:
		is_grounded = false
	

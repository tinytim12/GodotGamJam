extends KinematicBody2D

export var is_kid = false
var GRAVITY = 32
var SPEED = 64
var JUMP_SPEED = -384
var velocity = Vector2.ZERO
var ground_normal = Vector2(0, -1)
var is_grounded = false
var jump_count = 0
var MAX_JUMPS = 2
var dir_vector = Vector2(1, 0) # default looking right

export(Texture) var char_texture

func _ready():
	if is_kid == true:
		GRAVITY = -32
		SPEED = 64
		JUMP_SPEED = 384
		ground_normal = Vector2(0, 1)
		$Sprite.texture = char_texture


func _physics_process(_delta):
	# input handling
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
	
	# now only double jump
	if Input.is_action_just_pressed("ui_up") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_SPEED
		jump_count += 1
	# apply gravity
	velocity.y += GRAVITY
	# move and slide 
	velocity = move_and_slide(velocity, ground_normal)
	# check for reached ground
	if is_on_floor():
		is_grounded = true
		jump_count = 0
	else:
		is_grounded = false
	

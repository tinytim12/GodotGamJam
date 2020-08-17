extends KinematicBody2D

export var is_kid = false
export(Texture) var char_texture

var TARGET_FPS = 60

var GRAVITY = 512
var SPEED = 64
var JUMP_SPEED = -192
var velocity = Vector2.ZERO
var ground_normal = Vector2(0, -1)
var is_grounded = false
var jump_count = 0
var MAX_JUMPS = 2
var dir_vector = Vector2(1, 0) # default looking right

var childSpeedModifier = 20

onready var player_sprite = get_node("Sprite")
onready var player_camera = get_node("MainCamera")

var tilemap_rect
var tilemap_cell_size

func _ready():
	Engine.set_target_fps(TARGET_FPS)
	if is_kid == true:
		GRAVITY = -GRAVITY
		SPEED = SPEED
		JUMP_SPEED = -JUMP_SPEED
		ground_normal = -ground_normal
		player_sprite.texture = char_texture
		player_camera.current = false
		player_sprite.flip_v = true

	# camera settings
	tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	tilemap_cell_size = get_parent().get_node("TileMap").cell_size
	player_camera.limit_right = tilemap_rect.end.x * tilemap_cell_size.x


func _physics_process(delta):
	# input handling
	if Input.is_action_pressed("ui_left"):
		if is_kid == true:
			velocity.x = -SPEED + childSpeedModifier
		else:
			velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		if is_kid == true:
			velocity.x = SPEED - childSpeedModifier
		else:
			velocity.x = SPEED
	elif is_kid == true:
		var distance = get_node("/root/Level/Parent").position.x - position.x
		if ( abs(distance) >1):
			if (distance < 0):
				velocity.x = -SPEED + childSpeedModifier
				#print("too far")
			else:
				velocity.x = SPEED - childSpeedModifier
		else: 
			velocity.x = 0
	else:
		velocity.x = 0
	
	# restrict to number of jumps
	if Input.is_action_just_pressed("ui_up") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_SPEED
		jump_count += 1
	# apply gravity
	velocity.y += GRAVITY * delta
	# move and slide 
	velocity = move_and_slide(velocity, ground_normal)
	# check for ground
	if is_on_floor():
		is_grounded = true
		jump_count = 0
	else:
		is_grounded = false
	# update the player art and animation
	update_player()

# update the player art and animation
func update_player():
	if(velocity.x < 0):
		player_sprite.flip_h = true	
	elif(velocity.x > 0):
		player_sprite.flip_h = false


extends KinematicBody2D

export var is_kid = false
export(NodePath) var parentP
export(Texture) var char_texture
export(int) var threshold

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

# ------------------------------------------------------------------------------
# Kid reddening effect
# ------------------------------------------------------------------------------
var dangerDistance = 15
var reddenRate = 0.002
var lightRate = 30
var cameraThreshold = 35
var _timer = null

onready var parent = get_node(parentP)
onready var camera = parent.get_node("MainCamera")
onready var light = get_node("KidEffects/Light2D")
onready var red = get_node("KidEffects/TextureRect")
# ------------------------------------------------------------------------------

func _ready():
	Engine.set_target_fps(TARGET_FPS)
	if is_kid == true:
		GRAVITY = -GRAVITY
		SPEED = SPEED #- childSpeedModifier
		JUMP_SPEED = -JUMP_SPEED
		ground_normal = -ground_normal
		player_sprite.texture = char_texture
		player_camera.current = false
		player_sprite.flip_v = true
# ------------------------------------------------------------------------------
		light.set("energy", 0.0)
		threshold = 50
		
		_timer = Timer.new()
		add_child(_timer)
	
		_timer.connect("timeout", self, "_on_Timer_timeout")
		_timer.set_wait_time(0.2)
		_timer.set_one_shot(false) # Make sure it loops
		_timer.start()
		 
		red.modulate.a = 0
# ------------------------------------------------------------------------------
		# remove camera
		$MainCamera.queue_free()
	else:
		# parent remove the kid effects 
		$KidEffects.queue_free()
	
	# camera settings for parent
	if get_parent().get_node("TileMap") != null:
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
		var distance = parent.position.x - position.x
		if (abs(distance) > 1):
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


# ------------------------------------------------------------------------------
# kid reddening effect
# ------------------------------------------------------------------------------
func _on_Timer_timeout():
	#print("Second!")
	_checkDistance()


func _checkDistance():
	var distance = abs(position.x - parent.position.x)
	if (distance > dangerDistance):
		light.set("energy", distance / lightRate);
		threshold -= 1;
		if (red.modulate.a < 0.7):
			red.modulate.a = reddenRate * distance
			#print("red.modulate.a")
		if (threshold < 0):
			_gameOver()
			
		if (threshold < cameraThreshold):
			camera.set_offset(Vector2( \
		rand_range(-1.0, 1.0) * (cameraThreshold - threshold ) / 5, \
		rand_range(-1.0, 1.0) * (cameraThreshold - threshold ) / 5 \
	))
	else:
		threshold = 50
		red.modulate.a = 0
		if light != null:
			light.set("energy", 0)


func _gameOver():
	get_tree().reload_current_scene()


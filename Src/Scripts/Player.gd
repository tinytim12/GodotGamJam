extends KinematicBody2D

export var is_kid = false
export(NodePath) var parentP
export(NodePath) var textureRectP
export(Texture) var char_texture

export(int) var threshold
export var danger_tile_dist = 3.0
export(int) var childJumpModifier;
export(int) var childSpeedModifier;

#adult values
export(int) var adultJumpModifier;
export(int) var adultSpeedModifier;

export(bool)var kid_stronger;

var TARGET_FPS = 60
var tile_size = Vector2(16, 16)
var GRAVITY = 512
var SPEED = 64
var JUMP_SPEED = -192
var velocity = Vector2.ZERO
var ground_normal = Vector2(0, -1)
var is_grounded = false
var jump_count = 0
var MAX_JUMPS = 2
var dir_vector = Vector2(1, 0) # default looking right

onready var player_sprite = get_node("Sprite")
onready var player_camera = get_node("MainCamera")

var tilemap_rect
var tilemap_cell_size

# kid movement


# ------------------------------------------------------------------------------
# Kid reddening effect
# ------------------------------------------------------------------------------
var dangerDistance = 60
var reddenRate = 0.05
var lightRate = 20
var thresholdRate = 0.05
var shakeRate = 0.07
onready var parent = get_node(parentP)
onready var camera = parent.get_node("MainCamera")
onready var light = get_node("KidEffects/Light2D")
onready var red_effect = get_node(textureRectP)
# ------------------------------------------------------------------------------

func _ready():
	Engine.set_target_fps(TARGET_FPS)
	dangerDistance = danger_tile_dist * tile_size.x
	if kid_stronger == true:
		if is_kid == false:
			#if child is stronger, remove camera from adult.
			$MainCamera.queue_free()
	if is_kid == true:
		GRAVITY = -GRAVITY
		SPEED = SPEED #- childSpeedModifier
		JUMP_SPEED = -JUMP_SPEED
		ground_normal = -ground_normal
		player_sprite.texture = char_texture
		player_camera.current = false
		player_sprite.flip_v = true
		print("WRONG")
# ------------------------------------------------------------------------------
		light.set("energy", 0.0)
		threshold = 50
		red_effect.modulate.a = 0
# ------------------------------------------------------------------------------
		# remove camera
		if kid_stronger == false:
			print("queued")
			$MainCamera.queue_free()
		# set size of the color effect
		red_effect.rect_min_size = Vector2(960, 540)
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
	if kid_stronger == false:
		if is_kid == true:
			var distance = parent.position.x - position.x
			if (abs(distance) > 1):
				if (distance < 0):
					velocity.x = -SPEED + childSpeedModifier
					#print("too far")
				else:
					velocity.x = SPEED - childSpeedModifier
			else: 
				velocity.x = 0
		elif Input.is_action_pressed("ui_left"):
			if is_kid == true:
				velocity.x = -SPEED + childSpeedModifier
			else:
				velocity.x = -SPEED + adultSpeedModifier
		elif Input.is_action_pressed("ui_right"):
			if is_kid == true:
				velocity.x = SPEED - childSpeedModifier
			else:
				velocity.x = SPEED - adultSpeedModifier
		
		else:
			velocity.x = 0
	#if this is the part of the game where the child is stronger than the adult 
	else: 
		
		if Input.is_action_pressed("ui_left"):
			if is_kid == true:
				velocity.x = -SPEED + childSpeedModifier
			else:
				velocity.x = -SPEED + adultSpeedModifier
		elif Input.is_action_pressed("ui_right"):
			if is_kid == true:
				velocity.x = SPEED - childSpeedModifier
			else:
				velocity.x = SPEED - adultSpeedModifier
		elif is_kid == true:
			var distance = parent.position.x - position.x
			if (abs(distance) > 20):
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
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept") ) and jump_count < MAX_JUMPS:
		if is_kid == true:
			velocity.y = JUMP_SPEED - childJumpModifier
		else:
			velocity.y = JUMP_SPEED + adultJumpModifier
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
	_checkDistance(delta)


# update the player art and animation
func update_player():
	if(velocity.x < 0):
		player_sprite.flip_h = true	
	elif(velocity.x > 0):
		player_sprite.flip_h = false


# ------------------------------------------------------------------------------
# kid reddening effect
# ------------------------------------------------------------------------------

func _checkDistance(delta):
	var distance = abs( position.x - parent.position.x )
	if (distance > dangerDistance):
		light.set("energy", distance *  delta );
		threshold -= thresholdRate * distance * delta;
		if (red_effect.modulate.a < 0.5):
			red_effect.modulate.a = lerp(red_effect.modulate.a, reddenRate * distance * delta , 0.2)
			#print("red_effect.modulate.a")
		if (threshold < 0):
			_gameOver()
		print_debug(threshold)
		if (camera.trauma < 0.24):
			camera.add_trauma(shakeRate * distance * delta)
			print_debug("shake!!")
	else:
		threshold = 50
		if red_effect != null and red_effect.modulate.a > 0:
			red_effect.modulate.a = lerp(red_effect.modulate.a, 0 , 0.2)
		if light != null and light.energy > 0:
			light.energy = lerp(light.energy, 0, 0.2)


func _gameOver():
	get_tree().reload_current_scene()


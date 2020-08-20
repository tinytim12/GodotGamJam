extends KinematicBody2D

export var is_kid = false
export(NodePath) var parentP
export(NodePath) var textureRectP
export(Texture) var char_texture
export var danger_tile_dist = 3.0

#movement modifiers
export(int) var childSpeedModifier
export(int) var childJumpModifier
export(int) var adultSpeedModifier
export(int) var adultJumpModifier

export (bool) var kid_stronger
export (bool) var kidCatchingUp

var distanceThreshold

var GRAVITY = 512
var SPEED = 96
var JUMP_SPEED = -252
var SPEEDUP = 3
var velocity = Vector2.ZERO
var ground_normal = Vector2(0, -1)
var is_grounded = false
var jump_count = 0
var MAX_JUMPS = 2
var dir_vector = Vector2(1, 0) # default looking right

onready var player_sprite = get_node("Sprite")
onready var player_anim = get_node("AnimatedSprite")

var tilemap_rect
var tilemap_cell_size

# kid movement


# ------------------------------------------------------------------------------
# Kid reddening effect
# ------------------------------------------------------------------------------
var dangerDistance = 45
var reddenRate = 0.1
var lightRate = 30
var cameraThreshold = 0.1
var threshold = 200
onready var parent = get_node(parentP)
onready var red_effect = get_node(textureRectP)
onready var AudioMgr = get_parent().get_node("AudioMgr")

var childCatchingUp = false
# ------------------------------------------------------------------------------

func _ready():
	dangerDistance = danger_tile_dist * GData.TILE_SIZE.x
	if is_kid == true:
		GRAVITY = -GRAVITY
		SPEED = SPEED #- childSpeedModifier
		JUMP_SPEED = -JUMP_SPEED
		ground_normal = -ground_normal
		if player_sprite != null:
			#player_sprite.texture = char_texture
			player_anim = get_node("AnimatedSprite_Kid")
			player_sprite.flip_v = true
			player_anim.flip_v = true
# ------------------------------------------------------------------------------
		$Light.texture_scale = 1.2
		threshold = 50
		red_effect.modulate.a = 0
# ------------------------------------------------------------------------------
		# set size of the color effect
		red_effect.rect_min_size = Vector2(960, 540)
		$AnimatedSprite.queue_free()
	else:
		# parent remove the kid effects 
		$KidEffects.queue_free()
		$AnimatedSprite_Kid.queue_free()
	
	# camera settings for parent
	if get_parent().get_node("TileMap") != null:
		tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
		tilemap_cell_size = get_parent().get_node("TileMap").cell_size
		if GM.mainCamera != null:
			# what is this for ?
			GM.mainCamera.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
			if(is_kid and kid_stronger):
				GM.mainCamera.target = self
			elif(!is_kid and !kid_stronger):

				GM.mainCamera.target = self
			
func _physics_process(delta):
	# input handling
	var friction = false
	if Input.is_action_pressed("ui_left"):
		if is_kid == true:
			velocity.x = max(velocity.x - SPEEDUP + childSpeedModifier/100, -SPEED + childSpeedModifier)
		else:
			velocity.x = max(velocity.x - SPEEDUP + adultSpeedModifier/100, -SPEED + adultSpeedModifier)
	elif Input.is_action_pressed("ui_right"):
		if is_kid == true:
			velocity.x = min(velocity.x+SPEEDUP - childSpeedModifier / 100, SPEED - childSpeedModifier)
		else:
			velocity.x = min(velocity.x+SPEEDUP - adultSpeedModifier / 100, SPEED - adultSpeedModifier)
			
	elif(is_kid and get_distance_to_adult()):
		childCatchingUp = true;
		if (parent.position.x - position.x < 0):
			velocity.x = max(velocity.x - SPEEDUP + childSpeedModifier / 100, -SPEED + childSpeedModifier)
			#print("too far")
		else:
			velocity.x = min(velocity.x + SPEEDUP - childSpeedModifier / 100, SPEED - childSpeedModifier)
			
	else:
		friction = true
		
	
	# restrict to number of jumps
	if Input.is_action_just_pressed("player_jump") and jump_count < MAX_JUMPS:
		if is_kid == true:
			velocity.y = JUMP_SPEED - childJumpModifier
		else:
			velocity.y = JUMP_SPEED + adultJumpModifier
			if AudioMgr!= null:
				AudioMgr.play_sfx(GData.SFX.jump)
		jump_count += 1
	# apply gravity
	velocity.y += GRAVITY * delta
	# move and slide 
	velocity = move_and_slide(velocity, ground_normal)
	# check for ground
	if is_on_floor():
		if(friction==true):
			velocity.x = lerp(velocity.x, 0, 0.2)
		is_grounded = true
		jump_count = 0
	else:
		if(friction==true):
			velocity.x = lerp(velocity.x, 0, 0.05)
		is_grounded = false
	# update the player art and animation
	update_player()
	
	# Only the the kid requires to run this function:
	if is_kid:
		_checkDistance(delta)


# update the player art and animation
func update_player():
	
	if velocity.y > 0:
		player_anim.play("jumping")
	elif velocity.y < 0:
		player_anim.play("jumping")

	elif(Input.is_action_pressed("ui_left") or (childCatchingUp)):
		if(velocity.y == 0):
			player_anim.play("walking")
		if(velocity.x < 0):
			player_anim.flip_h = true
			player_sprite.flip_h = true	
		elif(velocity.x > 0):
			player_anim.flip_h = false
			player_sprite.flip_h = false	
	elif(Input.is_action_pressed("ui_right") or (childCatchingUp)):
		if(velocity.y == 0):
			player_anim.play("walking")
		if(velocity.x < 0):
			player_anim.flip_h = true
			player_sprite.flip_h = true	
		elif(velocity.x > 0):
			player_anim.flip_h = false
			player_sprite.flip_h = false	
	
	else:

		player_anim.play("idle")
		


func get_distance_to_adult():
	if (!is_kid):
		return false
	var distance = parent.position.x - position.x
	if (abs(distance) > 5):
		
		return true;
	else:
		if(childCatchingUp and is_kid):
			childCatchingUp = false
		return false
		

# How far is player from each other based on tile size
func get_height_level(height_distance, tiles):
	var max_height = GData.TILE_SIZE.y * tiles
	return floor(height_distance / max_height )

# ------------------------------------------------------------------------------
# kid reddening effect
# ------------------------------------------------------------------------------

func _checkDistance(delta):
	var distance = abs(position.x - parent.position.x)
	var height = $Sprite.texture.get_height()
	var height_distance = height + abs(global_position.y) - abs(parent.position.y)
	
	# Camera smooth zoom effect
	if GM.mainCamera != null:
		# Follow center point between parent and kid
		GM.mainCamera.follow_center(global_position, parent.global_position)
		# Update zoom
		var height_level = get_height_level(height_distance, 4)
		var next_zoom = Vector2.ONE * height_level * 0.5
		GM.mainCamera.updateZoom(next_zoom, delta)
	
	if (distance > dangerDistance):
		# Toggle lights
		$Light.set("energy", distance *  delta );
		threshold -= 0.01 * distance * delta;
		if (red_effect.modulate.a < 0.64):
			red_effect.modulate.a = lerp(red_effect.modulate.a, reddenRate * distance * delta , 0.2)
		if (threshold < 0):
			_gameOver()
			
		# Camera shake effect
		if (GM.mainCamera != null and GM.mainCamera.trauma < 0.24):
			GM.mainCamera.add_trauma(cameraThreshold * distance * delta)
			
	else:
		threshold = 50
		if red_effect != null and red_effect.modulate.a > 0:
			red_effect.modulate.a = lerp(red_effect.modulate.a, 0 , 0.2)
		if $Light.energy > 1:
			$Light.energy = lerp($Light.energy, 1, 0.2)

func _gameOver():
	get_tree().reload_current_scene()




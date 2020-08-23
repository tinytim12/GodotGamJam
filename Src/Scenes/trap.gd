extends Panel
export var wait_time = 0.5
export var active_time = 0.5
export var jump_required = true
export var sequence_index = 0
export var delay_sequence = 0.25
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = wait_time
	$Timer.connect("timeout", self, "handle_time_out")
	$Active_timer.wait_time = active_time
	$Active_timer.connect("timeout", self, "handle_active_out")
	$Area2D.connect("body_entered", self, "handle_body_entered")
	$AnimationPlayer.connect("animation_finished", self, "handle_animation_finished")
	if sequence_index <= 0:
		sequence_index = 1
	yield(get_tree().create_timer(delay_sequence * sequence_index), "timeout")
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func activate():
	$Timer.start()

func desactive():
	$Active_timer.start()
	
	
func handle_body_entered(body):
	if body.is_in_group("player"):
		if jump_required or (!jump_required and active): 
			body._gameOver()

func handle_animation_finished(anim):
	if anim == "UP":
		desactive()
	if anim == "DOWN":
		active = false
		activate()
		
		
func handle_time_out():
	active = true
	$AnimationPlayer.play("UP")
	# play sound
	if GM.audio_mgr != null and GM.fox_cub != null:
		if abs(GM.fox_cub.position.x - get_position().x) < (GData.TILE_SIZE.x * 10):
			GM.audio_mgr.play_sfx(GData.SFX.trap)
	
func handle_active_out():
	$AnimationPlayer.play("DOWN")
	

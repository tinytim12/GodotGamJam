extends Light2D

export(NodePath) var playerP
export(NodePath) var childP
export(NodePath) var redP
export(NodePath) var cameraP;
export(int) var threshold
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var _timer = null
onready var red = get_node(redP)
onready var child = get_node(childP)
onready var player = get_node(playerP)
onready var camera = get_node(cameraP)

func _ready():
	set("energy", 0.0)
	
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.2)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	 
	red = get_node(redP)
	red.modulate.a = 0

func _on_Timer_timeout():
	print("Second!")
	_checkDistance()
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
	
func _checkDistance():
	
	var distance = abs(child.position.x - player.position.x);
	if (distance > 10):
		set("energy", distance / 10);
		threshold -= distance/100
		
		red.modulate.a = .005 * distance
		print("red.modulate.a")
		if (threshold < 0):
			print("GAMEOVER")
			
		if (distance > 15):
			camera.set_offset(Vector2( \
		rand_range(-1.0, 1.0) * (distance - 15) / 10, \
		rand_range(-1.0, 1.0) * (distance- 15) / 10 \
	))
	else:
		threshold = 100000
		red.modulate.a = 0
		set("energy", 0)
		

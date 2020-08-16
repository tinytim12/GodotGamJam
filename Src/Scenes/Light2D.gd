extends Light2D

export(NodePath) var playerP
export(NodePath) var childP
export(int) var threshold
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var _timer = null


func _ready():
	set("energy", 0.0)
	
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.2)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_Timer_timeout():
	print("Second!")
	_checkDistance()
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
	
func _checkDistance():
	var child = get_node(childP)
	var player = get_node(playerP)
	var distance = abs(child.position.x - player.position.x);
	if (distance > 10):
		set("energy", distance / 10);
		threshold -= distance/100
		if (threshold < 0):
			print("GAMEOVER")
			print (distance)
	else:
		threshold = 100000
		

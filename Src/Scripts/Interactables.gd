extends Area2D

export (String, "Star", "Key", "Switch", "Door" ) var itype

signal OnInteraction(val)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_entered(body):
	print("Hey")
	if (body.name == "Kid"):
		emit_signal("OnInteraction", itype, "Kid")
	elif (body.name == "Parent"):
		emit_signal("OnInteraction", itype, "Parent")
	if (itype != "Door"):
		self.queue_free()

	

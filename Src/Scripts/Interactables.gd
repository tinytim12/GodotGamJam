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
	if (body.name == "Parent"):
		self.queue_free()
		emit_signal("OnInteraction", itype)

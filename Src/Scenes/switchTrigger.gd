extends Area2D
export(NodePath) var tileMapP

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var on = false

onready var map = get_node(tileMapP)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if(!on):
		if (body.get_name() == "Parent"):
			on = true
			map.set_cell(4,4,-1)
			print("triggered")
	pass # Replace with function body.

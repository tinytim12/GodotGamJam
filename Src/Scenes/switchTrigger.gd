extends Area2D
export(NodePath) var tileMapP

var on = false
onready var map = get_node(tileMapP)

func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if(!on):
		if (body.get_name() == "Parent"):
			on = true
			map.set_cell(4,4,-1)
			print("triggered")


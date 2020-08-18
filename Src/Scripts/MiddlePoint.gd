extends Node2D

# Position point that the camera will follow

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var new_postion = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	if GM.fox_parent and GM.fox_cub:
		new_postion = get_center_position(GM.fox_parent.global_position, GM.fox_cub.global_position)
		global_position = new_postion
	pass # Replace with function body.



func get_center_position(a, b):
	var center = Vector2.ZERO
	center.x = (a.x + b.x) / 2
	center.y = (a.y + b.y) / 2
	return center

func _process(delta):
	if GM.fox_parent and GM.fox_cub:
		new_postion = get_center_position(GM.fox_parent.global_position, GM.fox_cub.global_position)
		global_position.x = lerp(global_position.x, new_postion.x, 0.4)
		global_position.y = lerp(global_position.y, new_postion.y, 0.4)

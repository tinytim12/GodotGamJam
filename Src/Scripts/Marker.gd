extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# TODO: Probably a better way to get the camera
onready var camera = GM.mainCamera

var margin = 10

func _process( _delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	if GM.mainCamera != null:
		# global_position = target.global_transform.origin
		set_marker_position(Rect2(top_left, size))
		set_marker_rotation()


func set_marker_rotation():
	var angle = (global_position - $Sprite.global_position).angle()
	$Sprite.global_rotation = angle

func set_marker_position(bounds):
	$Sprite.global_position.x = clamp(global_position.x, bounds.position.x + margin, bounds.end.x - margin)
	$Sprite.global_position.y = clamp(global_position.y, bounds.position.y + margin, bounds.end.y - margin)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()

extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var currentScene = get_tree().get_current_scene()
onready var mainCamera = currentScene.get_node_or_null('MainCamera')
onready var fox_cub = currentScene.get_node_or_null('Parent')
onready var fox_parent = currentScene.get_node_or_null('Kid')
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_level():
	currentScene = get_tree().get_current_scene()
	mainCamera = currentScene.get_node_or_null('MainCamera')
	fox_cub = currentScene.get_node_or_null('Parent')
	fox_parent = currentScene.get_node_or_null('Kid')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

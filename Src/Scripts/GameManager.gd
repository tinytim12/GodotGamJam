extends Node

onready var currentScene = get_tree().get_current_scene()
onready var mainCamera = currentScene.get_node_or_null('MainCamera')
onready var fox_cub = currentScene.get_node_or_null('Parent')
onready var fox_parent = currentScene.get_node_or_null('Kid')
onready var audio_mgr = currentScene.get_node_or_null('AudioMgr')

# Call this function at the start of each level
func init_level():
	currentScene = get_tree().get_current_scene()
	mainCamera = currentScene.get_node_or_null('MainCamera')
	fox_cub = currentScene.get_node_or_null('Parent')
	fox_parent = currentScene.get_node_or_null('Kid')
	audio_mgr = currentScene.get_node_or_null('AudioMgr')

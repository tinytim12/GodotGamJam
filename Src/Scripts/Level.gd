extends Node2D

export (String, FILE) var prev_scene
export (String, FILE) var next_scene
var mainmenu_scene = "res://Scenes/MainMenu2D.tscn"

onready var AudioMgr = get_node("AudioMgr")
onready var hud = get_node("HUD")


func _ready():
	# Find important sfuff: like main camera and players
	GM.init_level()
	# initialize HUD
	hud.init_hud(prev_scene, next_scene, mainmenu_scene)
	# should this neede to be enabled ?
	#GM.audio_mgr.play_sfx(GData.SFX.kid)


# load main menu
func load_mainmenu_scene():
	get_tree().change_scene(mainmenu_scene)


# load prev scene
func load_prev_scene():
	get_tree().change_scene(prev_scene)


# load next scene
func load_next_scene():
	get_tree().change_scene(next_scene)


func _OnInteraction(val):
	print("_OnInteraction : " + str(val))
	if val == "Switch":
		var gates = get_tree().get_nodes_in_group ("Gate")
		for gate in gates:
			gate.queue_free()
		print_debug("_OnInteraction : Switch")
		if AudioMgr != null:
			AudioMgr.play_sfx(GData.SFX.switch)
	elif val == "Door":
		print_debug("_OnInteraction : Door")
		if AudioMgr != null:
			AudioMgr.play_sfx(GData.SFX.rune)
		load_next_scene()
	elif val == "Star":
		print_debug ("_OnInteraction : Collected Star")
		if AudioMgr != null:
			AudioMgr.play_sfx(GData.SFX.star)
	elif val == "Key":
		print_debug ("_OnInteraction : Collected Key")
		if AudioMgr != null:
			AudioMgr.play_sfx(GData.SFX.star)


func find_node_by_name(root, name):
	if(root.get_name() == name): 
		return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = find_node_by_name(child, name)
		if(found): 
			return found
	return null

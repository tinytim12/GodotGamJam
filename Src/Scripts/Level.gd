extends Node2D

export (String, FILE) var prev_scene
export (String, FILE) var next_scene
var mainmenu_scene = "res://Scenes/MainMenu2D.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Find important scene nodes: players and camera, etc.
	GM.init_level()
	pass # Replace with function body.


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
		
		var gate = find_node_by_name(get_tree().get_root(), "Gate")
		gate.queue_free()
		print ("Switched on")
	elif val == "Door":
		load_next_scene()
	elif val == "Star":
		print ("Collected Star")
	elif val == "Key":
		print ("Collected Key")


func find_node_by_name(root, name):

	if(root.get_name() == name): return root

	for child in root.get_children():
		if(child.get_name() == name):
			return child

		var found = find_node_by_name(child, name)

		if(found): return found

	return null

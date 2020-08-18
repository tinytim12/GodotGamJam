extends Node2D

export (String, FILE) var prev_scene
export (String, FILE) var next_scene
var mainmenu_scene = "res://Scenes/MainMenu2D.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
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
		print ("Switched on")
	if val == "Door":
		load_next_scene()
	elif val == "Star":
		print ("Collected Star")
	elif val == "Key":
		print ("Collected Key")

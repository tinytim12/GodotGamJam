extends Node2D

export(String) var level_name

var prev_scene
var next_scene
var mainmenu_scene
 
onready var AudioMgr = get_parent().get_node("AudioMgr")


func _ready():
	$CanvasLayer/LevelName.text = level_name
	pass 


func init_hud(prev_scene_val, next_scene_val, mainmenu_scene_val):
	prev_scene = prev_scene_val
	next_scene = next_scene_val
	mainmenu_scene = mainmenu_scene_val


# load main menu
func _on_main_menu():
	if mainmenu_scene != null:
		get_tree().change_scene(mainmenu_scene)
	if AudioMgr != null:
		AudioMgr.play_sfx(GData.SFX.button_click)


# load prev scene
func _on_prev_scene():
	if prev_scene != null:
		get_tree().change_scene(prev_scene)
	if AudioMgr != null:
		AudioMgr.play_sfx(GData.SFX.button_click)


# load next scene
func _on_next_scene ():
	if next_scene != null:
		get_tree().change_scene(next_scene)
	if AudioMgr != null:
		AudioMgr.play_sfx(GData.SFX.button_click)


extends Node2D


func _ready():
	Engine.target_fps = GData.TARGET_FPS
	$AudioMgr.play_sfx(GData.SFX.parent)


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		load_level()


func _on_Play_button_up():
	$AudioMgr.play_sfx(GData.SFX.button_click)
	load_level()


func load_level():
	get_tree().change_scene("res://Scenes/Chapter1.tscn")


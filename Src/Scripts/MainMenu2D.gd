extends Node2D


func _ready():
	Engine.target_fps = GData.TARGET_FPS


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		load_level()


func _on_Play_button_up():
	load_level()


func load_level():
	get_tree().change_scene("res://Scenes/Level_01.tscn")


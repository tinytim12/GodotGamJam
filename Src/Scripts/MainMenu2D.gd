extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		load_level()


func _on_Play_button_up():
	load_level()


func load_level():
	get_tree().change_scene("res://Scenes/Level_01.tscn")

extends Area2D

export (String) var story_text
onready var story_content = get_node("RichTextLabel")
onready var story_bg = get_node("Sprite")


func _ready():
	story_content.text = story_text
	story_content.hide()
	story_bg.hide()


func _on_player_entered(body):
	if body.name == "Parent":
		story_content.show()
		story_bg.show()
		GM.audio_mgr.play_sfx(GData.SFX.parent)


func _on_player_exited(body):
	if body.name == "Parent":
		story_content.hide()
		story_bg.hide()


extends Area2D

export (String) var story_text
onready var story_content = get_node("RichTextLabel")


func _ready():
	story_content.text = story_text
	story_content.hide()


func _on_player_entered(body):
	if body.name == "Parent":
		story_content.show()


func _on_player_exited(body):
	if body.name == "Parent":
		story_content.hide()

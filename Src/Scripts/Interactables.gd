extends Area2D

export (String, "Star", "Key", "Switch", "Door" ) var itype

signal OnInteraction(val)

var switch_off
var switch_on

func _ready():
	switch_off = get_node("Sprite")
	switch_on = get_node("SpriteOn")
	if switch_off != null and switch_on != null:
		switch_off.show()
		switch_on.hide()


func _on_Player_entered(body):
	var is_player = false
	if (body.name == "Kid"):
		emit_signal("OnInteraction", itype, "Kid")
		is_player = true
	elif (body.name == "Parent"):
		is_player = true
		emit_signal("OnInteraction", itype, "Parent")
	
	if itype == "Switch" and is_player:
		if switch_off != null and switch_on != null:
			switch_off.hide()
			switch_on.show()

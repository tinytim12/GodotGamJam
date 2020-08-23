extends Node

# only for datas

var TARGET_FPS = 60
var TILE_SIZE = Vector2(16, 16)
var WINDOW_SIZE = Vector2(480, 270)

var SFX_VOLUME = 0
var MUSIC_VOLUME = 0

var GAME_PROGRESS = 0 # completed levels

enum SFX { 
	button_click = 0,
	walk = 1,
	jump = 2,
	key = 10,
	switch = 11,
	star = 12,
	rune = 13,
	door = 14,
	trap = 15,
	warning = 20,
	death = 21,
	gameover = 22,
	parent = 31,
	kid = 32,
} 

func _ready():
	pass


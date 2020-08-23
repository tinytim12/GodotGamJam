extends Node2D

export(AudioStream) var button_click
export(AudioStream) var sfx_warning
export(AudioStream) var trap
export(AudioStream) var death
export(AudioStream) var gameover

export(Array, AudioStream) var walks
export(Array, AudioStream) var jumps
export(Array, AudioStream) var keys
export(Array, AudioStream) var runes
export(Array, AudioStream) var parents
export(Array, AudioStream) var kids


var cur_sfx_player = 0
var rng = RandomNumberGenerator.new()

onready var music_player_0 = get_node("Music_players/music_player_0")

onready var sfx_player_0 = get_node("SFX_players/sfx_player_0")
onready var sfx_player_1 = get_node("SFX_players/sfx_player_1")
onready var sfx_player_2 = get_node("SFX_players/sfx_player_2")
onready var sfx_player_3 = get_node("SFX_players/sfx_player_3")


func _ready():
	rng.randomize()
	play_muisic()
	

func play_muisic():
	#print_debug("Music")
	music_player_0.play()


func play_sfx(val):
	if cur_sfx_player == 1:
		sfx_player_1.stream = get_audio_stream(val)
		sfx_player_1.play()
	elif cur_sfx_player == 2:
		sfx_player_2.stream = get_audio_stream(val)
		sfx_player_2.play()
	elif cur_sfx_player == 3:
		sfx_player_3.stream = get_audio_stream(val)
		sfx_player_3.play()
	else:
		sfx_player_0.stream = get_audio_stream(val)
		sfx_player_0.play()
	# multiple sfx
	cur_sfx_player += 1;
	if cur_sfx_player >= 3:
		cur_sfx_player = 0


func get_audio_stream(val):
	match val:
		GData.SFX.button_click:
			return button_click
		GData.SFX.walk:
			return walks[rng.randi_range(0, walks.size()-1)]
		GData.SFX.jump:
			return jumps[rng.randi_range(0, jumps.size()-1)]
		GData.SFX.key:
			return keys[rng.randi_range(0, keys.size()-1)]
		GData.SFX.switch:
			return keys[rng.randi_range(0, keys.size()-1)]
		GData.SFX.star:
			return keys[rng.randi_range(0, keys.size()-1)]
		GData.SFX.door:
			return runes[rng.randi_range(0, runes.size()-1)]
		GData.SFX.trap:
			return trap
		GData.SFX.death:
			return death
		GData.SFX.gameover:
			return gameover
		GData.SFX.rune:
			return runes[rng.randi_range(0, runes.size()-1)]
		GData.SFX.parent:
			return parents[rng.randi_range(0, parents.size()-1)]
		GData.SFX.kid:
			return kids[rng.randi_range(0, kids.size()-1)]
		GData.SFX.warning:
			return sfx_warning


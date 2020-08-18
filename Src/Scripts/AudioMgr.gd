extends Node2D

export(AudioStream) var button_click
export(AudioStream) var sfx_warning

export(Array, AudioStream) var walks
export(Array, AudioStream) var jumps
export(Array, AudioStream) var keys
export(Array, AudioStream) var runes
export(Array, AudioStream) var parents
export(Array, AudioStream) var kids


var cur_sfx_player = 0
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	pass 
	

func play_muisic():
	print_debug("Music")
	$Music/music_player.play()


func play_sfx(val):
	if cur_sfx_player == 1:
		$SFX_player/sfx_player1.stream = get_audio_stream(val)
		print_debug($SFX_player/sfx_player1.stream.resource_name)
		$SFX_player/sfx_player1.play()
	elif cur_sfx_player == 2:
		$SFX_player/sfx_player2.stream = get_audio_stream(val)
		print_debug($SFX_player/sfx_player2.stream.resource_name)
		$SFX_player/sfx_player2.play()
	else:
		$SFX_player/sfx_player0.stream = get_audio_stream(val)
		print_debug($SFX_player/sfx_player0.stream.resource_name)
		$SFX_player/sfx_player0.play()
	# multiple sfx
	cur_sfx_player += 1;
	if cur_sfx_player >= 3:
		cur_sfx_player = 0


# values
#	button_click = 0,
#	walk = 1,
#	jump = 2,
#	keys = 10,
#	switch = 11,
#	star = 12,
#	rune = 13,
#	door = 14,
#	warning = 20,
#	parent = 31,
#	kid = 32,

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
		GData.SFX.rune:
			return runes[rng.randi_range(0, runes.size()-1)]
		GData.SFX.parent:
			return parents[rng.randi_range(0, parents.size()-1)]
		GData.SFX.kid:
			return kids[rng.randi_range(0, kids.size()-1)]
		GData.SFX.warning:
			return sfx_warning
	#if val == GData.SFX.button_click:


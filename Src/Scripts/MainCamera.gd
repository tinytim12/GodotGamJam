extends Camera2D
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

var max_zoom = 1
var min_zoom = 0.64
var zoom_speed = 1.4
var follow_speed = 1.4

var target = null
var target_position = null

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	if target:
		target_position = target.global_position
	if target_position:
		global_position = lerp(global_position, target_position, delta * follow_speed)
func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)

func updateZoom(new_zoom, delta = 1):
	var fixed_zoom = Vector2.ONE
	# Horizontal zoom
	fixed_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	fixed_zoom.x = lerp(zoom.x, fixed_zoom.x, delta * zoom_speed)
	# Vertical zoom
	fixed_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	fixed_zoom.y = lerp(zoom.y, fixed_zoom.y,  delta * zoom_speed)
	# update zoom
	zoom = fixed_zoom

func follow_center(a, b):
	var center = Vector2.ZERO
	center.x = (a.x + b.x) / 2
	center.y = (a.y + b.y) / 2
	target_position = center

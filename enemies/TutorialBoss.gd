extends Node2D

export var max_tilt_angle = PI

export var x_radius = 50.0
export var y_radius = 50.0
export var x_rate = 0.2
export var y_rate = 0.1

var x_angle = 0.0
var y_angle = 0.0

onready var start_position = Vector2.ZERO
onready var prev_position = Vector2.ZERO

func _ready():
	start_position = position
	prev_position = position

# https://medium.com/@wjjordan00/how-to-make-gorgeous-lissajous-patterns-in-unity-easy-2f6423bbe045
func _physics_process(delta):
	x_angle += x_rate * delta
	y_angle += y_rate * delta
	
	while x_angle >= 2 * PI:
		x_angle -= 2 * PI
	while y_angle >= 2 * PI:
		y_angle -= 2 * PI

	var cur_position = Vector2(start_position.x + sin(x_angle) * x_radius, start_position.y + cos(y_angle) * y_radius)
	var position_diff = (cur_position - prev_position) / delta
	
	prev_position = position
	position = cur_position
	rotation = clamp(position_diff.x, -240.0, 240.0) / 240.0 * PI / 16

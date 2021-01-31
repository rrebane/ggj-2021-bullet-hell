extends Node2D

class_name Enemy

enum STATES {ENTERING_ARENA, ACTIVE}

export var max_tilt_angle = PI

export var x_radius = 50.0
export var y_radius = 50.0
export var x_rate = 0.15
export var y_rate = 0.075

export var y_enter_arena_offset = -50
export var enter_arena_duration = 3

var x_angle = 0.0
var y_angle = PI
var cur_state = STATES.ENTERING_ARENA
var cur_enter_arena_time = 0.0
var cur_idle_time = 0.0

onready var start_position = Vector2.ZERO
onready var prev_position = Vector2.ZERO
onready var enter_arena_start_position = Vector2.ZERO
onready var enter_arena_end_position = Vector2.ZERO

func _ready():
	start_position = position
	prev_position = position
	
	enter_arena_end_position = Vector2(start_position.x + sin(x_angle) * x_radius, start_position.y + cos(y_angle) * y_radius)
	enter_arena_start_position = enter_arena_end_position + Vector2(0, y_enter_arena_offset)

	cur_state = STATES.ENTERING_ARENA
	cur_enter_arena_time = 0.0
	position = enter_arena_start_position

# https://medium.com/@wjjordan00/how-to-make-gorgeous-lissajous-patterns-in-unity-easy-2f6423bbe045
func _physics_process(delta):
	match cur_state:
		STATES.ENTERING_ARENA:
			enter_arena(delta)
		STATES.ACTIVE:
			move_in_pattern(delta)

func enter_arena(delta):
	cur_enter_arena_time += delta
	
	if cur_enter_arena_time >= enter_arena_duration:
		position = enter_arena_end_position
		cur_state = STATES.ACTIVE
		for child_module in get_children():
			child_module.active = true
	else:
		var interpolation_val = 1 - cur_enter_arena_time / enter_arena_duration
		position = enter_arena_end_position.linear_interpolate(enter_arena_start_position, interpolation_val * interpolation_val)

func move_in_pattern(delta):
	x_angle += x_rate * delta
	y_angle += y_rate * delta
	
	while x_angle >= 2 * PI:
		x_angle -= 2 * PI
	while y_angle >= PI + 2 * PI:
		y_angle -= 2 * PI

	var cur_position = Vector2(start_position.x + sin(x_angle) * x_radius, start_position.y + cos(y_angle) * y_radius)
	var position_diff = (cur_position - prev_position) / delta
	
	prev_position = position
	position = cur_position
	rotation = clamp(position_diff.x, -240.0, 240.0) / 240.0 * PI / 16

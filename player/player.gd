extends KinematicBody2D

onready var VELOCITY = Vector2.ZERO;
onready var DASH_SPEED = 1000;
onready var DRAG = 0.1;
onready var SPEED = 250;
onready var PRE_DASH_VELOCITY = Vector2.ZERO;
onready var DASHING = false;
onready var DASH_ON_COOLDOWN = false;
onready var DASH_COOLDOWN_DURATION = 0.5;
onready var DASH_DURATION = 10;
onready var DASH_MULTIPLIER = 2;
onready var DASH_FRAMES = 10;
onready var X_DIR = 0;
onready var Y_DIR = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handle_movement(delta);
	pass


func handle_movement(delta):
	VELOCITY = Vector2.ZERO
	if not DASHING:
		if Input.is_action_pressed("up"):
			VELOCITY.y = SPEED;
			Y_DIR = 1;
		if Input.is_action_pressed("down"):
			VELOCITY.y = -SPEED;
			Y_DIR = -1;
		if Input.is_action_pressed("left"):
			VELOCITY.x = SPEED;
			X_DIR = 1;
		if Input.is_action_pressed("right"):
			VELOCITY.x = -SPEED;
			X_DIR = -1;
		if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
			X_DIR = 0;
		if Input.is_action_just_released("down") or Input.is_action_just_released("up"):
			Y_DIR = 0;
			
		if Input.is_action_pressed("dash") and not DASH_ON_COOLDOWN:
			DASH_FRAMES = DASH_DURATION;
			DASH_ON_COOLDOWN = true;
			DASHING = true;
#
	if DASHING:
		dash();
	move_and_slide(VELOCITY);
	
	
func dash():
	VELOCITY.x = X_DIR * DASH_SPEED;
	VELOCITY.y = Y_DIR * DASH_SPEED;
	DASH_FRAMES -= 1;
	if DASH_FRAMES == 0:
		DASHING = false;
		yield(get_tree().create_timer(DASH_COOLDOWN_DURATION), "timeout")
		print("end")
		DASH_ON_COOLDOWN = false;
	
func hurt():
	print("I got hurt")

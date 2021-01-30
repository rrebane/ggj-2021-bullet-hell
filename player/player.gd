extends KinematicBody2D

onready var VELOCITY = Vector2.ZERO;
export var DASH_SPEED = 450;
export var SPEED = 150;
onready var DASHING = false;
onready var DASH_ON_COOLDOWN = false;
export var DASH_COOLDOWN_DURATION = 0.5;
export var DASH_DURATION = 8;
onready var DASH_FRAMES = 6;
onready var X_DIR = 0;
onready var Y_DIR = 0;

var destroyed = false

func _ready():
	$EnemyDetector.connect("body_entered", self, "hurt_enemy")

func _physics_process(delta):
	handle_movement(delta);
	
	if DASHING:
		modulate = Color(255, 255, 255)
	else:
		modulate = Color(0, 0, 0)

func hurt_enemy(coll):
	if destroyed:
		return
	if DASHING and coll.has_method("dash_kill"):
		coll.dash_kill()

func handle_movement(_delta):
	VELOCITY = Vector2.ZERO
	if not DASHING:
		if Input.is_action_pressed("down"):
			VELOCITY.y = SPEED;
			Y_DIR = 1;
		if Input.is_action_pressed("up"):
			VELOCITY.y = -SPEED;
			Y_DIR = -1;
		if Input.is_action_pressed("right"):
			VELOCITY.x = SPEED;
			X_DIR = 1;
		if Input.is_action_pressed("left"):
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
		DASH_ON_COOLDOWN = false;
	
func hurt():
	if DASHING:
		pass

extends KinematicBody2D

export var SPEED = 75
export var DASH_COOLDOWN_DURATION = 0.5
export var DASH_DURATION = 8
export var start_lives = 20
export var invulnerability_duration = 2

onready var DASH_SPEED = SPEED * 3
onready var VELOCITY = Vector2.ZERO
onready var DASHING = false
onready var DASH_ON_COOLDOWN = false
onready var start_position = Vector2.ZERO
onready var DASH_FRAMES = 6
onready var X_DIR = 0
onready var Y_DIR = 0

var invulnerable = false
var destroyed = false
var particles_obj = preload("res://effects/PlayerDestroyedParticles.tscn")

var lives = start_lives
var cur_invulnerability_time = 0.0

onready var explosion_sound = get_node("ExplosionSFX");
onready var dash_sound = get_node("DashSFX");

func _ready():
	$EnemyDetector.connect("body_entered", self, "hurt_enemy")
	
	start_position = position

func _physics_process(delta):
	if destroyed:
		return
	if invulnerable:
		cur_invulnerability_time += delta
		if cur_invulnerability_time >= invulnerability_duration:
			invulnerable = false
	handle_movement(delta);

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
			
		if Input.is_action_pressed("dash") and not DASH_ON_COOLDOWN and VELOCITY != Vector2.ZERO:
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
	if not dash_sound.playing:
		dash_sound.play();
	$Graphics/Trail.emitting = true;
	if DASH_FRAMES == 0:
		DASHING = false;
		yield(get_tree().create_timer(DASH_COOLDOWN_DURATION), "timeout")
		DASH_ON_COOLDOWN = false;
	
func hurt():
	if destroyed:
		return false
	if invulnerable:
		return true
	if DASHING:
		return true
	
	explosion_sound.play();
	destroyed = true
	spawn_destroyed_particles()
	VELOCITY = Vector2.ZERO
	DASHING = false
	$Graphics/Sprite.hide()

	if lives > 0:
		lives -= 1
		$RespawnTimer.start()
	
	return false

func respawn():
	if !destroyed:
		return
	if lives <= 0:
		return

	position = start_position
	$Graphics/Sprite.show()
	destroyed = false
	invulnerable = true
	cur_invulnerability_time = 0.0

func spawn_destroyed_particles():
	var particles_inst = particles_obj.instance()
	get_tree().get_root().add_child(particles_inst)
	particles_inst.global_position = global_position

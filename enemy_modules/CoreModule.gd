extends EnemyModule

export var num_bullet_arrays = 5
export var fire_rotation_step = 0.3
export var fire_rate = 0.5
export var pause_duration = 3

var bullet_obj = preload("res://projectiles/EnemyEnergyBullet.tscn")
onready var shoot_sound = get_node("ShootSFX");

var fire_rotation_offset = 0.0
var cur_fire_time = 0.0
var cur_pause_time = 0.0
var paused = false

func _process(delta):
	if !active:
		return
	if paused:
		cur_pause_time += delta
		if cur_pause_time >= pause_duration:
			paused = false
	else:
		cur_fire_time += delta
		while cur_fire_time >= fire_rate:
			fire()
			cur_fire_time -= fire_rate

func fire():
	play_shoot_sound();
	var angle_between_arrays = 2 * PI / num_bullet_arrays
	for n in range(num_bullet_arrays):
		var bullet_inst = bullet_obj.instance()
		get_tree().get_root().add_child(bullet_inst)
		bullet_inst.global_position = global_position
		var bullet_angle = n * angle_between_arrays
		bullet_inst.move_vec = Vector2.RIGHT.rotated(bullet_angle + fire_rotation_offset * angle_between_arrays)
	fire_rotation_offset += fire_rotation_step
	while fire_rotation_offset > 1.0:
		fire_rotation_offset -= 1.0
		pause_fire()

#func dash_kill():
#	pass

func pause_fire():
	if paused:
		return
	shoot_sound.stop();
	paused = true
	cur_pause_time = 0.0

func play_shoot_sound():
	shoot_sound.play();
	

func stop_shoot_sound():
	shoot_sound.stop();

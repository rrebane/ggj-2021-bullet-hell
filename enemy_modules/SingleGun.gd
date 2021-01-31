extends Node2D

export var fire_rate = 0.5

var cur_fire_time = 0.0

var bullet_obj = preload("res://projectiles/EnemyEnergyBullet.tscn")
var player : KinematicBody2D
onready var shoot_sound = get_node("../ShootSFX");

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta):
	if player.destroyed:
		return
	cur_fire_time += delta
	while cur_fire_time >= fire_rate:
		fire()
		cur_fire_time -= fire_rate
	
	var rotation_diff = get_global_transform().get_rotation() - rotation
	rotation = player.global_position.angle_to_point(global_position) + rotation_diff

func fire():
	shoot_sound.play();
	var bullet_inst = bullet_obj.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_position = global_position
	bullet_inst.move_vec = global_position.direction_to(player.global_position)

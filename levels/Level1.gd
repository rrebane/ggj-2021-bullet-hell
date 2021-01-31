extends Node2D

var enemy_objects = [
	preload("res://enemies/TutorialBoss.tscn"),
	preload("res://enemies/Boss3.tscn"),
]

onready var current_enemy_num = 0

func _ready():
	spawn_next_enemy()

func _process(delta):
	pass

func spawn_next_enemy():
	if current_enemy_num < len(enemy_objects):
		var enemy_inst = enemy_objects[current_enemy_num].instance()
		$Enemies.add_child(enemy_inst)
		enemy_inst.connect("died", self, "spawn_next_enemy")
		current_enemy_num += 1
	else:
		LevelManager.load_win_game()

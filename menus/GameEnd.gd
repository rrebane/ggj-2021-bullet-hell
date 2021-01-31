extends Control

onready var first_level = "res://levels/Level1.tscn"

func _process(delta):
	if Input.is_action_pressed("restart"):
		LevelManager.goto_scene(first_level)

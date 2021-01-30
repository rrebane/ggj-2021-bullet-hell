extends KinematicBody2D

class_name EnemyModule

onready var player_detector : Area2D

var dead = false

signal died

func _ready():
	if has_node("PlayerDetector"):
		player_detector = $PlayerDetector
		player_detector.connect("body_entered", self, "hurt_player")

func hurt_player(coll):
	if coll.has_method("hurt"):
		coll.hurt()

func _process(delta):
	pass

func kill():
	if dead:
		return
	dead = true
	emit_signal("died")
	queue_free()

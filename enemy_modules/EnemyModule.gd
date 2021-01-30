extends KinematicBody2D

class_name EnemyModule

onready var player_detector : Area2D

var dead = false
var particles_obj = preload("res://effects/ModuleDestroyedParticles.tscn")

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
	
func dash_kill():
	kill()

func kill():
	if dead:
		return
	dead = true
	var particles_inst = particles_obj.instance()
	get_tree().get_root().add_child(particles_inst)
	particles_inst.global_position = global_position
	emit_signal("died")
	queue_free()

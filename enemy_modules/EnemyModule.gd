extends KinematicBody2D

class_name EnemyModule

onready var player_detector : Area2D
onready var active = false

var dead = false
var particles_obj = preload("res://effects/ModuleDestroyedParticles.tscn")

signal died

func _ready():
	if has_node("PlayerDetector"):
		player_detector = $PlayerDetector
		player_detector.connect("body_entered", self, "hurt_player")

func hurt_player(coll):
	if coll.has_method("hurt"):
		if coll.hurt():
			kill()

func _process(delta):
	pass
	
func dash_kill():
	kill()

func kill():
	if dead:
		return
	dead = true
	spawn_destroyed_particles()
	emit_signal("died")
	queue_free()

func spawn_destroyed_particles():
	var particles_inst = particles_obj.instance()
	get_tree().get_root().add_child(particles_inst)
	particles_inst.global_position = global_position

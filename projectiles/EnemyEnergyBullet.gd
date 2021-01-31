extends KinematicBody2D

export var move_speed = 75
var move_vec : Vector2
var destroyed = false

func _ready():
	$PlayerDetector.connect("body_entered", self, "hurt_player")
	$DeleteTimer.start()

func hurt_player(coll):
	if destroyed:
		return
	if coll.has_method("hurt"):
		coll.hurt()
		destroy()

func _physics_process(delta):
	var coll = move_and_collide(move_vec * move_speed * delta)
	if coll:
		if destroyed:
			return
		if coll.collider.has_method("hurt"):
			coll.collider.hurt()
		destroy()
	if destroyed:
		if !$DestroyedParticles.emitting:
			queue_free()

func destroy():
	destroyed = true
	#$QueueFreeTimer.start()
	#$DestroyedParticles.restart()
	#$DestroyedParticles.emitting = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Graphics/Sprite.hide()
	#$HitSound.play()
	#$Graphics/AnimationPlayer.play("die")
	move_vec = Vector2.ZERO
	
func hurt():
	return true;

extends Sprite


var bullet_obj = preload("res://projectiles/EnemyEnergyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	#shoot_sound.play();
	var bullet_inst = bullet_obj.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_position = $bullet_spawn_point.global_position
	bullet_inst.move_vec = Vector2(0, -1);
	bullet_inst.set_collision_mask_bit(1, 1);

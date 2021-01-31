extends EnemyModule

var single_gun_module = preload("res://enemy_modules/SingleGunModulePickup.tscn");

func kill():
	var single_gun_instance = single_gun_module.instance()
	get_tree().get_root().add_child(single_gun_instance)
	single_gun_instance.global_position = global_position
	print("Kill from SingleGunModule")
	.kill(); # Call base class kill

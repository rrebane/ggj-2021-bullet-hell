extends EnemyModule

var single_gun_module = preload("res://enemy_modules/SingleGunModulePickup.tscn");
onready var level

func _ready():
	._ready()
	level = get_tree().get_nodes_in_group("level")[0]

func kill():
	var single_gun_instance = single_gun_module.instance()
	level.add_child(single_gun_instance)
	single_gun_instance.global_position = global_position
	.kill(); # Call base class kill

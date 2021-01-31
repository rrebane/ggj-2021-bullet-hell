extends Control

onready var lives = 4;

onready var health_ui_label = get_node("Label")

func _ready():
	Events.connect("player_take_damage", self, "on_hurt");
	pass # Replace with function body.

func on_hurt():
	print("Received signal")
	lives -= 1;
	if lives == 0:
		LevelManager.load_game_over();
	health_ui_label.visible = true;
	health_ui_label.text =  str(lives) + " lives left" if lives > 1 else "1 life left";
	yield(get_tree().create_timer(2), "timeout")
	health_ui_label.visible = false;
	

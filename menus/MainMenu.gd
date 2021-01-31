extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String, FILE) var first_level
export(String, FILE) var about_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartGame_pressed():
	LevelManager.goto_scene(first_level);
	pass # Replace with function body.


func _on_AboutMenu_pressed():
	LevelManager.goto_scene(about_menu);
	pass # Replace with function body.

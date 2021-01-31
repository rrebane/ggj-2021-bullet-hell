extends Node2D


func _on_Area2D_body_entered(coll):
	if coll.has_method("pickup"):
		print("pickup")
		coll.pickup("single_gun")
		queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	$Area2D/CollisionShape2D.disabled = false;
	pass # Replace with function body.

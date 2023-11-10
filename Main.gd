extends Node2D



func _on_schliessen_pressed():
	get_tree().quit()


func _on_spielen_pressed():
	get_tree().change_scene("res://world.tscn")

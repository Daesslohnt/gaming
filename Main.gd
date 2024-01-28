extends Node2D


func _on_start_button_pressed():
	get_tree().change_scene("res://world.tscn")


func _on_schliessen_button_pressed():
	get_tree().quit()

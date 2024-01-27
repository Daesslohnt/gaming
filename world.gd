extends Node2D


func _on_Poltava_pressed():
	get_tree().change_scene("res://battle_scenes/PoltavaIntro.tscn")


func _on_Narva_pressed():
	get_tree().change_scene("res://battle_scenes/NarvaIntro.tscn")

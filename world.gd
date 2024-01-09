extends Node2D



func _on_TextureButton_pressed():
	print("pressed")
	get_tree().change_scene("res://battle_scenes/NarvaIntro.tscn")

extends Node2D

var textureRect
var button
var textures = [
	preload("res://assets/intro/Poltava/start_img.jpg"),
	preload("res://assets/intro/Poltava/map_instruction.jpg")
]

func _ready():
	textureRect = $TextureRect
	button = $Button

	var currentIndex = 0
	textureRect.texture = textures[currentIndex]
	textureRect.set_expand(true)

	button.connect("pressed", self, "_onButtonPressed", [currentIndex])

func _onButtonPressed(index):
	var currentIndex = index
	currentIndex += 1
	if currentIndex == textures.size()-1:
		button.text = "Start"
	if currentIndex == textures.size():
		get_tree().change_scene("res://battle_scenes/NarvaBattle.tscn")
		return

	textureRect.texture = textures[currentIndex]
	textureRect.set_expand(true)

	button.disconnect("pressed", self, "_onButtonPressed")
	button.connect("pressed", self, "_onButtonPressed", [currentIndex])

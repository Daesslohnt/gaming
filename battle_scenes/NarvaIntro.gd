extends Node2D

var textureRect
var button
var textures = [
	preload("res://assets/intro/Narva/fiel_marshal_carl_gustav.jpg"),
	preload("res://assets/intro/Narva/sw1.jpg")
] # Füge hier deine Texturen hinzu

func _ready():
	textureRect = $TextureRect
	button = $Button

	# Setze den Startindex und die erste Textur
	var currentIndex = 0
	textureRect.texture = textures[currentIndex]

	# Verknüpfe das 'pressed' Signal des Buttons mit einer Funktion
	button.connect("pressed", self, "_onButtonPressed", [currentIndex])

func _onButtonPressed(index):
	# Hole den aktuellen Index aus dem Argument
	var currentIndex = index
	# Inkrementiere den Index oder setze ihn auf 0, wenn er das Ende erreicht hat
	currentIndex += 1
	if currentIndex >= textures.size():
		currentIndex = 0

	# Aktualisiere die Texture im TextureRect mit der neuen Textur
	textureRect.texture = textures[currentIndex]
	textureRect.set_expand(true)

	# Aktualisiere den Index im Button-Signal, um den neuen Index beim nächsten Drücken zu haben
	button.disconnect("pressed", self, "_onButtonPressed")
	button.connect("pressed", self, "_onButtonPressed", [currentIndex])

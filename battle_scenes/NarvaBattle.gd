extends Node2D

	
var sw_infantry1
var sw_infantry2

# This script is attached to the ParentNode.

func _ready():
	# Assuming `ParentNode/SenderNode` is the path to the sender node
	$ru_infantry1.connect("enemy_clicked", self, "_on_enemy_clicked_sw1")
	$ru_infantry2.connect("enemy_clicked", self, "_on_enemy_clicked_sw2")
	$sw_infantry1.connect("do_damage", self, "_on_do_damage_sw1_ru1")
	sw_infantry1 = $sw_infantry1
	sw_infantry2 = $sw_infantry2
	

func _on_enemy_clicked_sw1(click_position):
	# Handle the signal from the SenderNode
	print(click_position)
	sw_infantry1._on_enemy_clicked(click_position)

func _on_enemy_clicked_sw2(click_position):
	# Handle the signal from the SenderNode
	print(click_position)
	sw_infantry2._on_enemy_clicked(click_position)

func _on_do_damage_sw1_ru1(dm):
	print('Damage', dm)

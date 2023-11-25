extends Node2D

	
var sw_infantry1
var sw_infantry2

var ru_infantry1
var ru_infantry2

# This script is attached to the ParentNode.

func _ready():
	# click on enemy
	$ru_infantry1.connect("enemy_clicked", self, "_on_enemy_clicked")
	$ru_infantry2.connect("enemy_clicked", self, "_on_enemy_clicked")
	
	sw_infantry1 = $sw_infantry1
	sw_infantry2 = $sw_infantry2
	
	ru_infantry1 = $ru_infantry1
	ru_infantry2 = $ru_infantry2
	
	sw_infantry1.is_player = true
	sw_infantry2.is_player = true
	

func _on_enemy_clicked(enemy_unit):
	print("got signal")
	print(enemy_unit.position)
	sw_infantry1._attack_enemy(enemy_unit)
	sw_infantry2._attack_enemy(enemy_unit)


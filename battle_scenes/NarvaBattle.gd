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
	# deal damage
	$sw_infantry1.connect("do_damage", self, "_on_do_damage_to_ru")
	$sw_infantry2.connect("do_damage", self, "_on_do_damage_to_ru")
	# become dead
	$ru_infantry1.connect("iam_dead", self, "_on_become_dead")
	$ru_infantry2.connect("iam_dead", self, "_on_become_dead")
	
	sw_infantry1 = $sw_infantry1
	sw_infantry2 = $sw_infantry2
	
	ru_infantry1 = $ru_infantry1
	ru_infantry2 = $ru_infantry2
	

func _on_enemy_clicked(click_position):
	sw_infantry1._on_enemy_clicked(click_position)
	sw_infantry2._on_enemy_clicked(click_position)


func _on_do_damage_to_ru(dm, pos):
	if ru_infantry1.check_clicked(pos):
		print("Damge to RU1: ", dm)
		ru_infantry1.get_damaged(dm)
	elif ru_infantry2.check_clicked(pos):
		print("Damge to RU2: ", dm)
		ru_infantry2.get_damaged(dm)

func _on_become_dead():
	print("here should be destruction of unit")

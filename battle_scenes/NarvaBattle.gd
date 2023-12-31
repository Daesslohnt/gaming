extends Node2D


var sw_infantry1
var sw_infantry2
var sw_light_cavalery1
var sw_heavy_cavalery1


var ru_infantry1
var ru_infantry2

# This script is attached to the ParentNode.

func _ready():
	
	sw_infantry1 = $units/sw_infantry1
	sw_infantry2 = $units/sw_infantry2
	sw_light_cavalery1 = $units/sw_light_cavalery1
	sw_heavy_cavalery1 = $units/sw_heavy_cavalery1
	
	ru_infantry1 = $units/ru_infantry1
	ru_infantry2 = $units/ru_infantry2
	
	# death
	sw_infantry1.connect("iam_dead", self, "_on_dead")
	sw_infantry2.connect("iam_dead", self, "_on_dead")
	sw_heavy_cavalery1.connect("iam_dead", self, "_on_dead")
	sw_light_cavalery1.connect("iam_dead", self, "_on_dead")
	ru_infantry1.connect("iam_dead", self, "_on_dead")
	ru_infantry2.connect("iam_dead", self, "_on_dead")
	
	# click on enemy
	ru_infantry1.connect("enemy_clicked", self, "_on_enemy_clicked")
	ru_infantry2.connect("enemy_clicked", self, "_on_enemy_clicked")
	
	# receiving info
	sw_infantry1.connect("get_info", self, "_on_get_info")
	sw_infantry2.connect("get_info", self, "_on_get_info")
	sw_light_cavalery1.connect("get_info", self, "_on_get_info")
	sw_heavy_cavalery1.connect("get_info", self, "_on_get_info")
	
	sw_infantry1.is_player = true
	sw_infantry2.is_player = true
	sw_light_cavalery1.is_player = true
	sw_heavy_cavalery1.is_player = true
	
	# AI
	var enemy_list = [sw_infantry1, sw_infantry2, sw_light_cavalery1, sw_heavy_cavalery1]
	ru_infantry1.potential_targets = enemy_list
	ru_infantry2.potential_targets = enemy_list
	

func _on_enemy_clicked(enemy_unit):
	print("got signal")
	sw_infantry1._attack_enemy(enemy_unit)
	sw_infantry2._attack_enemy(enemy_unit)
	sw_light_cavalery1._attack_enemy(enemy_unit)
	sw_heavy_cavalery1._attack_enemy(enemy_unit)

func _on_get_info(info_text):
	$NarvaBattleCamera/Panel/Label.text = info_text

func _on_dead(attacker):
	for unit in $units.get_children():
		unit.enemy_dead_protocol(attacker)

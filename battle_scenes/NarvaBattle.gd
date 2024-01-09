extends Node2D


var sw_infantry1
var sw_infantry2
var sw_light_cavalery1
var sw_heavy_cavalery1
var sw_cannons1


var ru_infantry1
var ru_infantry2
var ru_light_cavalery1
var ru_heavy_cavalery1
var ru_cannons1

var player_list
var enemy_list

# This script is attached to the ParentNode.

func _ready():
	
	sw_infantry1 = $units/sw_infantry1
	sw_infantry2 = $units/sw_infantry2
	sw_light_cavalery1 = $units/sw_light_cavalery1
	sw_heavy_cavalery1 = $units/sw_heavy_cavalery1
	sw_cannons1 = $units/sw_cannons1
	
	ru_infantry1 = $units/ru_infantry1
	ru_infantry2 = $units/ru_infantry2
	ru_light_cavalery1 = $units/ru_light_cavalery1
	ru_heavy_cavalery1 = $units/ru_heavy_cavalery1
	ru_cannons1 = $units/ru_cannons1
	
	# death
	sw_infantry1.connect("iam_dead", self, "_on_dead")
	sw_infantry2.connect("iam_dead", self, "_on_dead")
	sw_heavy_cavalery1.connect("iam_dead", self, "_on_dead")
	sw_light_cavalery1.connect("iam_dead", self, "_on_dead")
	sw_cannons1.connect("iam_dead", self, "_on_dead")
	ru_infantry1.connect("iam_dead", self, "_on_dead")
	ru_infantry2.connect("iam_dead", self, "_on_dead")
	ru_light_cavalery1.connect("iam_dead", self, "_on_dead")
	ru_heavy_cavalery1.connect("iam_dead", self, "_on_dead")
	ru_cannons1.connect("iam_dead", self, "_on_dead")
	
	# click on enemy
	ru_infantry1.connect("enemy_clicked", self, "_on_enemy_clicked")
	ru_infantry2.connect("enemy_clicked", self, "_on_enemy_clicked")
	ru_light_cavalery1.connect("enemy_clicked", self, "_on_enemy_clicked")
	ru_heavy_cavalery1.connect("enemy_clicked", self, "_on_enemy_clicked")
	ru_cannons1.connect("enemy_clicked", self, "_on_enemy_clicked")
	
	# receiving info
	sw_infantry1.connect("get_info", self, "_on_get_info")
	sw_infantry2.connect("get_info", self, "_on_get_info")
	sw_light_cavalery1.connect("get_info", self, "_on_get_info")
	sw_heavy_cavalery1.connect("get_info", self, "_on_get_info")
	sw_cannons1.connect("get_info", self, "_on_get_info")
	
	# player units
	player_list = [sw_infantry1, sw_infantry2, sw_light_cavalery1, sw_heavy_cavalery1, sw_cannons1]
	for player_unit in player_list:
		player_unit.is_player = true
	
	# AI
	enemy_list = [ru_infantry1, ru_infantry2, ru_light_cavalery1, ru_heavy_cavalery1, ru_cannons1]
	for enemy in enemy_list:
		enemy.potential_targets = player_list
		
	# strategy
	for enemy in enemy_list:
		enemy.strategy = "defense"
	

func _on_enemy_clicked(enemy_unit):
	print("got signal")
	for player_unit in player_list:
		player_unit._attack_enemy(enemy_unit)

func _on_get_info(info_text, img):
	$NarvaBattleCamera/Panel/Label.text = info_text
	if img != null:
		$NarvaBattleCamera/Panel/TextureRect.texture = img
		$NarvaBattleCamera/Panel/TextureRect.set_expand(true)

func _on_dead(attacker):
	for unit in $units.get_children():
		unit.enemy_dead_protocol(attacker)

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
	
	# player units
	player_list = $sw_units.get_children()
	for player_unit in player_list:
		player_unit.is_player = true
		player_unit.connect("get_info", self, "_on_get_info")
		player_unit.connect("iam_dead", self, "_on_dead")
	
	# AI
	enemy_list = $ru_units.get_children()
	for enemy in enemy_list:
		enemy.potential_targets = player_list
		enemy.strategy = "defense"
		enemy.connect("enemy_clicked", self, "_on_enemy_clicked")
		enemy.connect("iam_dead", self, "_on_dead")
		enemy.connect("erase_me", self, "_do_erasion")

func _physics_process(delta):
	if enemy_list.size() < 10:
		get_tree().change_scene("res://result_scene/sw_win.tscn")
	elif player_list.size() < 10:
		get_tree().change_scene("res://result_scene/sw_lost.tscn")
	for unit in player_list + enemy_list:
		if is_instance_valid(unit):
			var x = unit.position.x
			var y = unit.position.y
			if (x > 4600 or x < -2000
			or y > 2050 or y < -1650):
				for attacker in unit.attackers:
					unit.emit_signal("iam_dead", attacker)
				unit.emit_signal("erase_me", self)
				unit.queue_free()

func _on_enemy_clicked(enemy_unit):
	for player_unit in player_list:
		player_unit._attack_enemy(enemy_unit)

func _on_get_info(info_text, img):
	$NarvaBattleCamera/Panel/Label.text = info_text
	if img != null:
		$NarvaBattleCamera/Panel/TextureRect.texture = img
		$NarvaBattleCamera/Panel/TextureRect.set_expand(true)

func _on_dead(attacker):
	for unit in player_list + enemy_list:
		if is_instance_valid(unit):
			unit.enemy_dead_protocol(attacker)

func _do_erasion(unit):
	if unit in enemy_list:
		enemy_list.erase(unit)

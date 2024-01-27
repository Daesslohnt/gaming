extends Node2D


var player_list
var enemy_list

var march_on = false
var cavalery_march = false

# This script is attached to the ParentNode.

func _ready():
	
	$march.connect("finished", self, "_on_finish_march")
	$cavalery.connect("finished", self, "_on_finish_cavalery")
	
	# player units
	player_list = $ru_units.get_children()
	for player_unit in player_list:
		player_unit.is_player = true
		player_unit.connect("get_info", self, "_on_get_info")
		player_unit.connect("iam_dead", self, "_on_dead")
		player_unit.connect("march_on", self, "_on_march")
		player_unit.connect("cavalery_march", self, "_on_march")
	
	# AI
	enemy_list = $sw_units.get_children()
	for enemy in enemy_list:
		enemy.potential_targets = player_list
		enemy.strategy = "defense"
		enemy.connect("enemy_clicked", self, "_on_enemy_clicked")
		enemy.connect("iam_dead", self, "_on_dead")
		enemy.connect("erase_me", self, "_do_erasion")
		enemy.connect("march_on", self, "_on_march")
		enemy.connect("cavalery_march", self, "_on_march")
	
	$background.start_audio_loop()

func _physics_process(delta):
	if enemy_list.size() < 10:
		get_tree().change_scene("res://result_scene/sw_win.tscn")
	elif player_list.size() < 10:
		get_tree().change_scene("res://result_scene/sw_lost.tscn")
	for unit in player_list + enemy_list:
		if is_instance_valid(unit):
			var x = unit.position.x
			var y = unit.position.y
			if (x > 6750 or x < -3750
			or y > 3750 or y < -3600):
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

func _on_march():
	if not march_on:
		$march.play()
		march_on = true
	if not cavalery_march:
		$cavalery.play()
		cavalery_march = true

func _on_finish_march():
	march_on = false

func _on_finish_cavalery():
	cavalery_march = false

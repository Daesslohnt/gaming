extends KinematicBody2D

var is_player = false

export var speed = 100
var velocity = Vector2(0, 0)
var click_position = Vector2(0, 0)
var target_position = Vector2(0, 0)
var attackers = []
var potential_targets = []
var enemy = null
var selected = false
var attack = false
var fire = false
var bayonet = false
var attack_mode = "fire"
var strategy = "defense"

# sprites
var sprite = NAN
var sprite_selection = NAN
var firing_sprite = NAN

var attack_time_1: float = 0
var attack_time_2: float = 6


# Mechanics
var HealthPoints = 100
var Discipline = 100
var DistanceDamage = 15
var CloseDamage = 40

signal enemy_clicked
signal get_info(text_info)
signal iam_dead

func _ready():
	click_position = Vector2(position.x, position.y)
	target_position = Vector2(position.x, position.y)
	sprite = $pictogram
	sprite_selection = $selection
	firing_sprite = $firing_sprite
	sprite.play("default")
	firing_sprite.play("none")
	sprite_selection.visible = false

func _physics_process(delta):
	attack_time_2 += delta
	if is_player:
		death_mechanics()
		slection_mechanic_player()
		movment_mechanic(delta)
		attack_mechanic()
	else:
		death_mechanics()
		selection_mechanic_npc()
		movment_mechanic(delta)
		attack_mechanic()
		if strategy == "defense":
			defese_strategy()

func selection_mechanic_npc():
	if Input.is_action_just_pressed("right_click"):
		var select_position = get_global_mouse_position()
		if check_clicked(select_position):
			emit_signal("enemy_clicked", self)

func slection_mechanic_player():
	if Input.is_action_just_pressed("left_click") and selected:
		click_position = get_global_mouse_position()
		selected = false
		attack = false
		sprite_selection.visible = false
		update_info(true)
	
	if Input.is_action_just_pressed("left_click") and not selected:
		var select_position = get_global_mouse_position()
		if check_clicked(select_position):
			selected = true
			sprite_selection.visible = true
			update_info(false)
	
	if Input.is_action_just_pressed("right_click") and selected:
		selected = false
		sprite_selection.visible = false
		update_info(true)
		
	if Input.is_action_just_pressed("1") and selected:
		attack_mode = "fire"
		attack = false
		bayonet = false
		update_info(false)
	
	if Input.is_action_just_pressed("2") and selected:
		fire = false
		attack = false
		attack_mode = "bayonet"
		update_info(false)
		
	if enemy == null:
		fire = false
		bayonet = false
		attack = false

func attack_mechanic():
	if attack and fire and attack_mode == "fire":
		if attack_time_2-attack_time_1 > 6:
			enemy.get_damaged(20, self)
			attack_time_2 = 0
		firing_sprite.play("firing")
	elif attack and bayonet and attack_mode == "bayonet":
		if attack_time_2-attack_time_1 > 6:
			enemy.get_damaged(20, self)
			attack_time_2 = 0
	else:
		firing_sprite.play("none")

func movment_mechanic(delta):
	if attack and attack_mode == "fire":
		if enemy != null and position.distance_to(enemy.position) > 300:
			target_position = (enemy.position - position).normalized()
			unit_movement(target_position, delta)
		else:
			click_position = position
			fire = true
	elif enemy != null and attack and attack_mode == "bayonet":
		if position.distance_to(enemy.position) > 120:
			target_position = (enemy.position - position).normalized()
		else:
			click_position = position
			bayonet = true
		unit_movement(target_position, delta)
	else:
		if enemy != null and position.distance_to(click_position) > 50:
			target_position = (click_position - position).normalized()
			unit_movement(target_position, delta)

func unit_movement(target_position, delta):
	var target_rotation_degree = rad2deg(target_position.angle()) + 90
	if abs(target_rotation_degree) < 120:
		rotation_degrees = lerp(rotation_degrees, target_rotation_degree, 1.2 * delta)
	move_and_slide(target_position * speed)

func death_mechanics():
	if HealthPoints == 0:
		print("Dead!!!")
		for attacker in attackers:
			emit_signal("iam_dead", attacker)
		queue_free()
	elif HealthPoints < 25:
		sprite.play("dm3")
	elif HealthPoints < 50:
		sprite.play("dm2")
	elif HealthPoints < 75:
		sprite.play("dm1")

# strategies

func defese_strategy():
	if enemy == null:
		for pot_target in potential_targets:
			if position.distance_to(pot_target.position) < 300:
				enemy = pot_target
	if enemy != null:
		if position.distance_to(enemy.position) > 400:
			enemy = null
		elif position.distance_to(enemy.position) > 0:
			attack_mode = "fire"
			attack = true
		else:
			attack_mode = "bayonet"
			attack = true

# logic

func _attack_enemy(enemy_unit):
	print("Player clicked on an enemy.")
	if selected:
		enemy = enemy_unit
		attack = true
	selected = false
	sprite_selection.visible = false
	update_info(true)

func get_damaged(dm, attacker):
	print("get damaged ", dm)
	if not (attacker in attackers):
		attackers.append(attacker)
	HealthPoints -= dm
	if HealthPoints < 0:
		HealthPoints = 0
	
func check_clicked(pos):
	var collision = get_world_2d().direct_space_state.intersect_point(pos)
	if collision.size() > 0 and collision[0]["collider"] == self:
		return true
	return false

func update_info(empty):
	if empty:
		emit_signal("get_info", "")
	else:
		var info = "Unit: Infantry\nAttack mode: " + attack_mode + "\nHP: " + str(HealthPoints)
		emit_signal("get_info", info)

func enemy_dead_protocol(attacker):
	if self == attacker:
		potential_targets.erase(enemy)
		enemy = null
		attack = null

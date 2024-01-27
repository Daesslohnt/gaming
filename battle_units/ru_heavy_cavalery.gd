extends KinematicBody2D

var is_player = false

var velocity = Vector2(0, 0)
var click_position = Vector2(0, 0)
var target_position = Vector2(0, 0)
var attackers = []
var potential_targets = []
var enemy = null
var selected = false
var attack = false
var fire = false
var rapier = false
var attack_mode = "rapier"
var strategy = "defense"

# sprites
var sprite = NAN
var sprite_selection = NAN
var firing_sprite = NAN
var img = NAN

var attack_time_1: float = 0
var attack_time_2: float = 6


# Mechanics
export var speed = 100
var HealthPoints = 150
var DistanceDamage = 5
var CloseDamage = 30

signal enemy_clicked
signal get_info(text_info, img)
signal iam_dead
signal erase_me
signal cavalery_march

func _ready():
	click_position = Vector2(position.x, position.y)
	target_position = Vector2(position.x, position.y)
	sprite = $pictogram
	sprite_selection = $selection
	firing_sprite = $firing_sprite
	sprite.play("default")
	firing_sprite.play("none")
	sprite_selection.visible = false
	img = preload("res://assets/unit_images/ru_heavy_cavalery.jpg")

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
			defense_strategy(delta)
		elif strategy == "agressive":
			agressiv_strategy()

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
		sprite_selection.visible = false
		update_info(true)
		
	if Input.is_action_just_pressed("1") and selected:
		click_position = position
		attack_mode = "fire"
		attack = false
		rapier = false
		update_info(false)
	
	if Input.is_action_just_pressed("2") and selected:
		click_position = position
		fire = false
		attack = false
		attack_mode = "rapier"
		update_info(false)
		
	if enemy == null:
		fire = false
		rapier = false
		attack = false
		click_position = position
		target_position = position

func attack_mechanic():
	if attack and fire and attack_mode == "fire":
		if is_instance_valid(enemy) and attack_time_2-attack_time_1 > 6:
			enemy.get_damaged(DistanceDamage, self)
			attack_time_2 = 0
		firing_sprite.play("firing")
	elif attack and rapier and attack_mode == "rapier":
		if is_instance_valid(enemy) and attack_time_2-attack_time_1 > 6:
			enemy.get_damaged(CloseDamage, self)
			attack_time_2 = 0
	else:
		firing_sprite.play("none")

func movment_mechanic(delta):
	if is_instance_valid(enemy) and attack and attack_mode == "fire":
		if position.distance_to(enemy.position) > 300:
			target_position = (enemy.position - position).normalized()
			unit_movement(target_position, delta)
		else:
			click_position = position
			fire = true
	elif is_instance_valid(enemy) and attack and attack_mode == "rapier":
		if position.distance_to(enemy.position) > 120:
			target_position = (enemy.position - position).normalized()
		else:
			click_position = position
			rapier = true
		unit_movement(target_position, delta)
	else:
		if position.distance_to(click_position) > 50:
			target_position = (click_position - position).normalized()
			unit_movement(target_position, delta)

func unit_movement(target_position, delta):
	var target_rotation_degree = rad2deg(target_position.angle()) + 90
	if abs(target_rotation_degree) < 90:
		rotation_degrees = lerp(rotation_degrees, target_rotation_degree, 1.2 * delta)
	move_and_slide(target_position * speed)
	emit_signal("cavalery_march")

func death_mechanics():
	if HealthPoints == 0:
		print("Dead!!!")
		for attacker in attackers:
			emit_signal("iam_dead", attacker)
		emit_signal("erase_me", self)
		queue_free()
	elif HealthPoints < 25:
		sprite.play("dm3")
	elif HealthPoints < 50:
		sprite.play("dm2")
	elif HealthPoints < 100:
		sprite.play("dm1")

# strategies

func defense_strategy(delta):
	if HealthPoints > 50:
		if enemy == null:
			for pot_target in potential_targets:
				if is_instance_valid(pot_target) and position.distance_to(pot_target.position) < 300:
					enemy = pot_target
		elif is_instance_valid(enemy):
			if position.distance_to(enemy.position) > 300:
				enemy = null
			else:
				attack_mode = "rapier"
				attack = true
				rapier = true
	else:
		enemy = null
		attack = false
		if attackers.size() > 0:
			var middle_x = 0
			var middle_y = 0
			for attacker in attackers:
				if is_instance_valid(attacker):
					var mirror = 2 * position - attacker.position
					middle_x += mirror.x
					middle_y += mirror.y
			middle_x = middle_x / attackers.size()
			middle_y = middle_y / attackers.size()
			click_position = Vector2(middle_x, middle_y)

func agressiv_strategy():
	if enemy == null and len(potential_targets) > 0:
		var argmin = 0
		var min_dist = 100000
		for i in range(len(potential_targets)):
			var dist = position.distance_to(potential_targets[i].position)
			if dist < min_dist:
				argmin = i
				min_dist = dist
		enemy = potential_targets[argmin]
	if is_instance_valid(enemy):
		if position.distance_to(enemy.position) > 200:
			attack_mode = "fire"
			attack = true
		else:
			attack_mode = "rapier"
			attack = true

# logic

func _attack_enemy(enemy_unit):
	if selected:
		enemy = enemy_unit
		attack = true
	selected = false
	sprite_selection.visible = false
	update_info(true)

func get_damaged(dm, attacker):
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
		emit_signal("get_info", "", null)
	else:
		var info = "Einheit: Cuirassier\nAngriffsmodus: " + attack_mode + "\nTreffpunkte: " + str(HealthPoints)
		emit_signal("get_info", info, img)

func enemy_dead_protocol(attacker):
	if self == attacker:
		potential_targets.erase(attacker)
		attackers.erase(attacker)
		if attacker == enemy:
			enemy = null
		attack = false
		click_position = position
		target_position = position
		fire = false
		rapier = false

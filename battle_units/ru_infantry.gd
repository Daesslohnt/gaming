extends KinematicBody2D

var is_player = false

export var speed = 100
var velocity = Vector2(0, 0)
var click_position = Vector2(0, 0)
var attackers = []
var enemy = null
var selected = false
var fire_attack = false
var fire = false
var attack_mode = "fire"

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

signal enemy_clicked

func _ready():
	click_position = Vector2(position.x, position.y)
	sprite = $pictogram
	sprite_selection = $selection
	firing_sprite = $firing_sprite
	sprite.play("default")
	firing_sprite.play("none")
	sprite_selection.visible = false

func _physics_process(delta):
	attack_time_2 += delta
	if is_player:
		slection_mechanic_player()
		movment_mechanic(delta)
		attack_mechanic()
	else:
		selection_mechanic_npc()
		npc_mechanics()

func selection_mechanic_npc():
	if Input.is_action_just_pressed("right_click"):
		var select_position = get_global_mouse_position()
		if check_clicked(select_position):
			print("etwas")
			emit_signal("enemy_clicked", self)

func slection_mechanic_player():
	if Input.is_action_just_pressed("left_click") and selected:
		click_position = get_global_mouse_position()
		selected = false
		fire_attack = false
		#sprite.play("default")
		sprite_selection.visible = false
	
	if Input.is_action_just_pressed("left_click") and not selected:
		var select_position = get_global_mouse_position()
		if check_clicked(select_position):
			selected = true
			#sprite.play("default_selected")
			sprite_selection.visible = true
	
	if Input.is_action_just_pressed("right_click") and selected:
		selected = false
		#sprite.play("default")
		sprite_selection.visible = false
		
	if Input.is_action_just_pressed("1") and selected:
		attack_mode = "fire"
	
	if Input.is_action_just_pressed("2") and selected:
		fire = false
		fire_attack = false
		attack_mode = "pikes"
		
	if enemy == null:
		fire = false
		fire_attack = false

func attack_mechanic():
	if fire and attack_mode == "fire": # and position.distance_to(click_position) < 310
		if attack_time_2-attack_time_1 > 6:
			#emit_signal("do_damage", 20, enemy.position)
			enemy.get_damaged(20, self)
			attack_time_2 = 0
		firing_sprite.play("firing")
	else:
		firing_sprite.play("none")

func movment_mechanic(delta):
	if fire_attack:
		if position.distance_to(enemy.position) > 300:
			var target_position = (enemy.position - position).normalized()
			unit_movement(target_position, delta)
		else:
			click_position = position
			fire = true
	else:
		if position.distance_to(click_position) > 50:
			var target_position = (click_position - position).normalized()
			unit_movement(target_position, delta)
			fire = false

func unit_movement(target_position, delta):
	var target_rotation_degree = rad2deg(target_position.angle()) + 90
	if abs(target_rotation_degree) < 120:
		rotation_degrees = lerp(rotation_degrees, target_rotation_degree, 1.2 * delta)
	move_and_slide(target_position * speed)

func npc_mechanics():
	if HealthPoints == 0:
		print("Dead!!!")
		for attacker in attackers:
			attacker.enemy = null
		queue_free()
	elif HealthPoints < 25:
		sprite.play("dm3")
	elif HealthPoints < 50:
		sprite.play("dm2")
	elif HealthPoints < 75:
		sprite.play("dm1")

# strategies

func defece_strategy():
	pass

# logic

func _attack_enemy(enemy_unit):
	print("Player clicked on an enemy.")
	if selected:
		enemy = enemy_unit
		if attack_mode == "fire":
			fire_attack = true
	selected = false

func get_damaged(dm, attacker):
	print("get damaged ", dm)
	attackers.append(attacker)
	HealthPoints -= dm
	if HealthPoints < 0:
		HealthPoints = 0
	
func check_clicked(pos):
	var collision = get_world_2d().direct_space_state.intersect_point(pos)
	if collision.size() > 0 and collision[0]["collider"] == self:
		return true
	return false


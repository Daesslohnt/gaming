extends KinematicBody2D

export var speed = 100
var velocity = Vector2(0, 0)
var click_position = Vector2(0, 0)
var enemy_position = Vector2(0, 0)
var selected = false
var fire_attack = false
var fire = false
var pikes_attack = false
var pikes = false
var attack_mode = "fire"

# sprites
var sprite = NAN
var firing_sprite = NAN
var pikes_sprite = NAN

var fire_time_1: float = 0
var fire_time_2: float = 6

signal do_damage(dm, pos)

func _ready():
	click_position = Vector2(position.x, position.y)
	sprite = $pictogram
	firing_sprite = $firing_sprite
	pikes_sprite = $pikes_sprite
	sprite.play("default")
	firing_sprite.play("none")
	pikes_sprite.play("default")
	

func _physics_process(delta):
	fire_time_2 += delta
	slection_mechanic()
	
	movment_mechanic(delta)
	
	attack_mechanic()






func slection_mechanic():
	if Input.is_action_just_pressed("left_click") and selected:
		click_position = get_global_mouse_position()
		selected = false
		fire_attack = false
		sprite.play("default")
	
	if Input.is_action_just_pressed("right_click") and selected:
		selected = false
		sprite.play("default")
		
	if Input.is_action_just_pressed("1") and selected:
		pikes = false
		pikes_attack = false
		attack_mode = "fire"
		pikes_sprite.play("default")
	
	if Input.is_action_just_pressed("2") and selected:
		fire = false
		fire_attack = false
		pikes = true
		attack_mode = "pikes"
		pikes_sprite.play("pikes")

func attack_mechanic():
	if fire: # and position.distance_to(click_position) < 310
		if fire_time_2-fire_time_1 > 6:
			emit_signal("do_damage", 20, enemy_position)
			fire_time_2 = 0
		firing_sprite.play("firing")
	else:
		firing_sprite.play("none")

func movment_mechanic(delta):
	if fire_attack:
		if position.distance_to(enemy_position) > 300:
			var target_position = (enemy_position - position).normalized()
			unit_movement(target_position, delta)
		else:
			fire = true
	elif pikes_attack:
		if position.distance_to(enemy_position) > 50:
			var target_position = (enemy_position - position).normalized()
			unit_movement(target_position, delta)
		else:
			pikes = true
	else:
		if position.distance_to(click_position) > 50:
			var target_position = (click_position - position).normalized()
			unit_movement(target_position, delta)
			fire = false
			pikes = false

func unit_movement(target_position, delta):
	var target_rotation_degree = rad2deg(target_position.angle()) + 90
	if abs(target_rotation_degree) < 90:
		rotation_degrees = lerp(rotation_degrees, target_rotation_degree, 2.0 * delta)
	move_and_slide(target_position * speed)



# logic

func _on_enemy_clicked(pos):
	if selected:
		print("Player clicked on an enemy.")
		enemy_position = pos
		if attack_mode == "fire":
			fire_attack = true
		elif attack_mode == "pikes":
			pikes_attack = true


func _on_Button_pressed():
	selected = not selected
	if selected:
		sprite.play("default_selected")
		click_position = get_global_mouse_position()
	else:
		sprite.play("default")

extends KinematicBody2D

export var speed = 100
var velocity = Vector2(0, 0)
var click_position = Vector2(0, 0)
var enemy_position = Vector2(0, 0)
var selected = false
var attack = false
var fire = false
var sprite = NAN
var firing_sprite = NAN

var fire_time_1: float = 0
var fire_time_2: float = 6

signal do_damage(dm)

func _ready():
	click_position = Vector2(position.x, position.y)
	sprite = $pictogram
	firing_sprite = $firing_sprite
	sprite.play("default")
	firing_sprite.play("none")
	

func _physics_process(delta):
	fire_time_2 += delta
	if Input.is_action_just_pressed("left_click") and selected:
		click_position = get_global_mouse_position()
		selected = false
		sprite.play("default")
	
	if Input.is_action_just_pressed("right_click") and selected:
		selected = false
		sprite.play("default")
	
	var target_position = (click_position - position).normalized()
	
	
	if attack:
		if position.distance_to(click_position) > 300:
			var target_rotation_degree = rad2deg(target_position.angle()) + 90
			if abs(target_rotation_degree) < 90:
				rotation_degrees = lerp(rotation_degrees, target_rotation_degree, 2.0 * delta)
			move_and_slide(target_position * speed)
		else:
			attack = false
			fire = true
			click_position = position
	else:
		if position.distance_to(click_position) > 50:
			var target_rotation_degree = rad2deg(target_position.angle()) + 90
			if abs(target_rotation_degree) < 90:
				rotation_degrees = lerp(rotation_degrees, target_rotation_degree, 2.0 * delta)
			move_and_slide(target_position * speed)
			fire = false
	
	if fire and position.distance_to(click_position) < 310:
		if fire_time_2-fire_time_1 > 6:
			emit_signal("do_damage", 20)
			fire_time_2 = 0
		firing_sprite.play("firing")
	else:
		firing_sprite.play("none")

func _on_enemy_clicked(pos):
	print("Player clicked on an enemy.")
	click_position = pos
	attack = true
	

func _on_Button_pressed():
	selected = !selected
	if selected:
		sprite.play("default_selected")
	else:
		sprite.play("default")
	print("selection:", selected)

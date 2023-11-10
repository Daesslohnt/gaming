extends KinematicBody2D

export var speed = 100
var velocity = Vector2(0, 0)
var click_position = Vector2(0, 0)
var selected = false
var fire = true
var sprite = NAN
var firing = NAN

signal enemy_clicked(click_position)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_RIGHT:
			var click_position = get_global_mouse_position()
			var collision = get_world_2d().direct_space_state.intersect_point(click_position)
			if collision.size() > 0 and collision[0]["collider"] == self:
				emit_signal("enemy_clicked", click_position)
				print("ru clicked")

func _ready():
	click_position = Vector2(position.x, position.y)
	sprite = $pictogram
	firing = $firing_sprite
	sprite.play("default")
	firing.play("none")

func _physics_process(delta):
	if Input.is_action_just_pressed("left_click") and selected:
		click_position = get_global_mouse_position()
		selected = false
		
		sprite.play("default")
		
	var target_position = (click_position - position).normalized()
	
	if position.distance_to(click_position) > 50:
		move_and_slide(target_position * speed)
	if fire:
		firing.play("firing")
	else:
		firing.play("non")


func _on_Button_pressed():
	selected = !selected
	if selected:
		sprite.play("default_selected")
	else:
		sprite.play("default")

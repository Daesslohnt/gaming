extends KinematicBody2D

# narva battle camera
const SPEED = 500  # Adjust this to control the character's movement speed

var velocity = Vector2()

func _physics_process(delta):
	# Handle player input
	velocity = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	# Normalize the velocity vector to prevent diagonal movement from being faster
	velocity = velocity.normalized() * SPEED

	# Move the character
	move_and_slide(velocity)


func _on_WindowDialog_about_to_show():
	pass
	

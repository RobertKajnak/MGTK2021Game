extends KinematicBody2D

var velocity = Vector2.ZERO
export (int) var speed = 150
export (float) var acceleration = 0.5
export (float) var friction = 0.1

func _physics_process(delta):
	get_input() # Gyuri: nem szuper h minden updatenel meghivjuk
	velocity = move_and_slide(velocity)

func get_input():
	var traits = Global.get_traits()
	var can_move = traits.has(Global.Trait.Movement)
	var is_fast = traits.has(Global.Trait.Speed)
	
	var input_dir_x = 0
	var input_dir_y = 0
	
	if can_move:
		if Input.is_action_pressed("right"):
			input_dir_x += 1
		if Input.is_action_pressed("left"):
			input_dir_x -= 1
		if Input.is_action_pressed("up"):
			input_dir_y -= 1
		if Input.is_action_pressed("down"):
			input_dir_y += 1
			

	speed = 300 if is_fast else 150

	if input_dir_x != 0:
		velocity.x = lerp(velocity.x, input_dir_x * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

	if input_dir_y != 0:
		velocity.y = lerp(velocity.y, input_dir_y * speed, acceleration)
	else:
		velocity.y = lerp(velocity.y, 0, friction)
		


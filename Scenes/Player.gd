extends KinematicBody2D

var velocity = Vector2.ZERO
export (int) var speed = 150
const JUMP_DISTANCE = 800
export (float) var acceleration = 0.5
export (float) var friction = 0.1

func _physics_process(_delta):
	var traits = Global.get_traits()
	$PlayerTexture.visible = not traits.has(Global.Trait.Chameleon)
	var is_giant = traits.has(Global.Trait.Giant)
	if is_giant:
		$PlayerCollision.set_scale(Vector2(2,2))
		$PlayerTexture.set_scale(Vector2(1.176,1.29))
	else:
		$PlayerCollision.set_scale(Vector2(1,1))
		# Ezt igy kell csinalni, de vigyazat, sprite texture csere eseten elromlik (from Andor with love)
		$PlayerTexture.set_scale(Vector2(0.588,0.645))
	get_input(traits) # Gyuri: nem szuper h minden updatenel meghivjuk
	velocity = move_and_slide(velocity)
	

func get_input(traits):
	regular_move(traits)
	jump_move(traits)
	
func jump_move(traits):
	var can_jump = traits.has(Global.Trait.Jump)
	var inverse_movement = traits.has(Global.Trait.Inverse_Movement)
	
	var unit = JUMP_DISTANCE if not inverse_movement else -JUMP_DISTANCE
	
	var input_dir_x = 0
	var input_dir_y = 0
	
	if can_jump and Input.is_action_pressed("jump"):
		if Input.is_action_pressed("right"):
			input_dir_x += unit
		if Input.is_action_pressed("left"):
			input_dir_x -= unit
		if Input.is_action_pressed("up"):
			input_dir_y -= unit
		if Input.is_action_pressed("down"):
			input_dir_y += unit
	
		if input_dir_x != 0:
			velocity.x = lerp(velocity.x, input_dir_x, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)

		if input_dir_y != 0:
			velocity.y = lerp(velocity.y, input_dir_y, acceleration)
		else:
			velocity.y = lerp(velocity.y, 0, friction)
	
func regular_move(traits):
	var can_move = traits.has(Global.Trait.Movement)
	var is_fast = traits.has(Global.Trait.Speed)
	var inverse_movement = traits.has(Global.Trait.Inverse_Movement)
	
	var unit = 1 if not inverse_movement else -1
	
	var input_dir_x = 0
	var input_dir_y = 0
	
	if can_move:
		if Input.is_action_pressed("right"):
			input_dir_x += unit
		if Input.is_action_pressed("left"):
			input_dir_x -= unit
		if Input.is_action_pressed("up"):
			input_dir_y -= unit
		if Input.is_action_pressed("down"):
			input_dir_y += unit
			
	speed = 300 if is_fast else 150

	if input_dir_x != 0:
		velocity.x = lerp(velocity.x, input_dir_x * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

	if input_dir_y != 0:
		velocity.y = lerp(velocity.y, input_dir_y * speed, acceleration)
	else:
		velocity.y = lerp(velocity.y, 0, friction)
		


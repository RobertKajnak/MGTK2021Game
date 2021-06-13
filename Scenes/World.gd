extends Node2D

const LightTexture = preload("res://res/textures/Light.png")
const NORMAL_SIGHT_MULTIPLIER = 2.0
const SHORT_SIGHT_MULTIPLIER = 0.5
var player_start_position = Vector2.ZERO

var paused := false

onready var fog = $Fog
onready var camera = $Player/Camera2D

const GRID_WIDTH = 1000
const GRID_HEIGHT = 1000
var grid_map = {}

var camera_position = Vector2.ZERO
var sun_event_in_progress := false
var sun_event_start_time 
var sun_start_pos = Vector2(-1400,-1400)
var sun_end_pos = Vector2(2695 , 1565)
var sun_duration = 20
var sun_light_dry = 1
var sun_heavy_dry = 200

var display_width = ProjectSettings.get("display/window/size/width")
var display_height = ProjectSettings.get("display/window/size/height")

var fogImage = Image.new()
var fogTexture = ImageTexture.new()
var lightImage = LightTexture.get_data()
var lightImageWidth = 0
var lightImageHeight = 0
var light_offset = Vector2(LightTexture.get_width()/2, LightTexture.get_height()/2)

var current_time = 0

# For having a more efficient fog movement 
# Only update the fog if the player has moved
onready var player_position = $Player.position 

func _ready():
	randomize()
	
	player_start_position = $Player.position
	var camera_position = $Player/Camera2D.get_camera_position()
	
	var fog_image_width = display_width + 20
	var fog_image_height = display_height + 20
	
	Global.genome = \
		Global.trait_to_gene[Global.Trait.Absorption] + \
		Global.trait_to_gene[Global.Trait.Sight] + \
		Global.trait_to_gene[Global.Trait.Movement]
	update_genome()
	
	fogImage.create(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fogImage.fill(Color.black)
	lightImage.convert(Image.FORMAT_RGBAH)
	lightImageWidth = lightImage.get_width()
	lightImageHeight = lightImage.get_height()
	
	update_vision_radius(NORMAL_SIGHT_MULTIPLIER)
	update_fog($Player.position)
	start_sun_event()
	
func generate_flora(offsetx, offsety):
	# Spawn random RNA Fragments
	for _i in range(6 + randi()%10):
		var rna_obj = load("res://Scenes/RNA_Object.tscn").instance()
		# Check here for overlaps with objects (álmodj királylány)
		rna_obj.position = Vector2(offsetx + randi()%1000, offsety + randi()%1000)
		$RNA_nodes.add_child(rna_obj)
	
	# Spawn green food
	for _i in range(6 + randi()%4):
		var plant = load("res://Scenes/Food_object.tscn").instance()
		plant.position = Vector2(offsetx + randi()%1000,offsety + randi()%1000)
		$Plant_nodes.add_child(plant)
		
	# Spawn brown food
	for _i in range(3 + randi()%2):
		var brown = load("res://Scenes/Food_object_brown.tscn").instance()
		brown.position = Vector2(offsetx + randi()%1000,offsety + randi()%1000)
		$Brown_nodes.add_child(brown)
		
	#Spawn Rocks
	for _i in range(randi()%3):
		var rock = load("res://res/models/Rock.tscn").instance()
		rock.position = Vector2(offsetx + randi()%1000,offsety + randi()%1000)
		$Rocks.add_child(rock)
		
	#Spawn Cells
	for _i in range(1 + randi()%5):
		var cell = load("res://Scenes/Food_object_cell.tscn").instance()
		cell.position = Vector2(offsetx + randi()%1000,offsety + randi()%1000)
		$Cell_nodes.add_child(cell)
		
	#Spawn Water
	if randi()%2 == 0:
		var water = load("res://Scenes/Water.tscn").instance()
		water.position = Vector2(offsetx + randi()%1000,offsety + randi()%1000)
		$Cell_nodes.add_child(water)
	
func generate_grids():
	var current_grid = Vector2(int($Player.position.x / 1000), int($Player.position.y / 1000)) * 1000;
	
	for i in range(-1,2):
		for j in range(-1,2):
			var modified_grid = Vector2(current_grid.x +i*1000 , current_grid.y +j*1000)
			if not grid_map.has(modified_grid):
				grid_map[modified_grid] = true
				generate_flora(modified_grid.x, modified_grid.y)
	
func update_genome():
	$HUD.refresh()
	if Global.get_traits().has(Global.Trait.Photosensivity):
		$Sun.energy = 2.5
	else:
		$Sun.energy = 1
	
func update_vision_radius(new_radius):
	lightImage.resize(lightImageWidth*new_radius, lightImageHeight*new_radius)
	light_offset = Vector2(LightTexture.get_width()/2*new_radius, LightTexture.get_height()/2*new_radius)

func update_fog(lightOffsetModifier):
	var traits = Global.get_traits()
	var has_long_sight = traits.has(Global.Trait.Long_Vision)
	fog.visible = not has_long_sight
	if has_long_sight or OS.get_name() != "Windows":
		return
	fogImage.lock()
	lightImage.lock()
	
	fogImage.fill(Color.black)
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))
	fogImage.blend_rect(lightImage, light_rect, lightOffsetModifier - light_offset)

	fogImage.unlock()
	lightImage.unlock()
	update_fog_image_texture()

func update_fog_image_texture():
	fogTexture.create_from_image(fogImage)
	fog.texture = fogTexture
	fog.position = camera.get_camera_screen_center() - player_start_position - Vector2(10,10)

func _physics_process(delta):
	if paused:
		return
	var traits = Global.get_traits()
	generate_grids()
	
	var has_sight = traits.has(Global.Trait.Sight)
	update_vision_radius(NORMAL_SIGHT_MULTIPLIER if has_sight else SHORT_SIGHT_MULTIPLIER)
	var sense_cells = traits.has(Global.Trait.Sense_Cells)
	if sense_cells:
		$Cell_nodes.z_index = 2
	else:
		$Cell_nodes.z_index = 0
	
	# Only updates the flag, if the player has moved
	if $Player.position != player_position:
		if $Player.position.distance_to(player_position) > 0.1:
			#Camera moves instead of player
			update_fog($Player.position - ($Player/Camera2D.get_camera_position() - player_start_position))
		camera_position = $Player/Camera2D.get_camera_position()
		player_position = $Player.position
	
		#Water ingress
	if Global.in_water>0:
		Global.hydration += delta * sun_heavy_dry * 2
		Global.hydration = min(Global.hydration, 9950)

	
	#Sun event
	if sun_event_in_progress:
		$Sun.position = sun_start_pos + (sun_end_pos - sun_start_pos) * \
						((current_time - sun_event_start_time) / sun_duration) + ($Player/Camera2D.get_camera_position() - player_start_position)
		var in_shadow = not check_raycast()
		var sun_dist = $Sun.position.distance_to($Player.position)
		var hydration_modifier = 0
		if not in_shadow:
			if sun_dist<1050:
				hydration_modifier=delta*sun_heavy_dry * $Sun.energy
				if traits.has(Global.Trait.Water_Storage):
					 hydration_modifier/=3
				if traits.has(Global.Trait.Photosynthesis):
					Global.energy = min(5000, Global.energy + delta*sun_heavy_dry * $Sun.energy * 2	)
			elif sun_dist<1550:
				hydration_modifier=delta*sun_light_dry * $Sun.energy
				if traits.has(Global.Trait.Water_Storage):
					 hydration_modifier/=3
				if traits.has(Global.Trait.Photosynthesis):
					Global.energy = min(5000, Global.energy + delta*sun_light_dry * $Sun.energy * 2	)	
			Global.hydration -= hydration_modifier
			if current_time - sun_event_start_time >= sun_duration:
				sun_event_in_progress = false
	
	# Virus
	if traits.has(Global.Trait.Virus):
		Global.energy -= delta * 200 * 2
		
	if Global.hydration <= 0 or Global.energy <= 0:
		$Player.die()
		$HUD.die()
		die()
		
	if Global.DNACount >= 25:
		win()
		
	current_time += delta
	var energy_decay_modifier = 100
	if traits.has(Global.Trait.Better_Core):
		energy_decay_modifier = 40
	Global.energy -= delta * energy_decay_modifier

func check_raycast():
	var space_state = get_world_2d().get_direct_space_state()
	# use global coordinates, not local to node
	var result = space_state.intersect_ray( $Sun.position, $Player.position ).values()
	for item in result:
		if typeof(item) == 17:
			if item.get_class() == 'KinematicBody2D':
				return true
	return false

func die():
	$HUD.die()
	pause()
	
func win():
	$Player.die()
	$HUD.win()
	pause()
	
func pause():
	if paused:
		$Player.paused = false
		paused = false
	else:
		$Player.paused = true
		paused = true

func start_sun_event():
	sun_event_in_progress = true
	$Sun.position = sun_start_pos
	sun_event_start_time = current_time

func exit_game():
	get_tree().quit()

# Input handling
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_ESCAPE:
				exit_game() 
			if event.scancode == KEY_P:
				$HUD.pause()
				pause()
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# For Windows, if 'x' is clicked, alt-f4 etc.
		pass
	elif what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		# For android
		exit_game()
		
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN or what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		#Pause
		pass


func _on_SunTimer_timeout():
	start_sun_event()

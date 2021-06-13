extends Node2D

const LightTexture = preload("res://res/textures/Light.png")
const NORMAL_SIGHT_MULTIPLIER = 2.0
const SHORT_SIGHT_MULTIPLIER = 0.5

var paused := false

onready var fog = $Fog


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
var light_offset = Vector2(LightTexture.get_width()/2, LightTexture.get_height()/2)

var current_time = 0

# For having a more efficient fog movement 
# Only update the fog if the player has moved
onready var player_position = $Player.position 

func _ready():
	randomize()
	
	#$Player/Camera2D.position = $Player.position
	
	var fog_image_width = display_width
	var fog_image_height = display_height
	Global.genome = \
		Global.trait_to_gene[Global.Trait.Movement] + \
		Global.trait_to_gene[Global.Trait.Absorption] + \
		Global.trait_to_gene[Global.Trait.Sight]
	update_genome()
	
	fogImage.create(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fogImage.fill(Color.black)
	lightImage.convert(Image.FORMAT_RGBAH)
	
	# Spawn random RNA Fragments
	for _i in range(6 + randi()%10):
		var rna_obj = load("res://Scenes/RNA_Object.tscn").instance()
		rna_obj.set_collision_callback(self, "update_genome")
		# Check here for overlaps with objects (álmodj királylány)
		rna_obj.position = Vector2(100+randi()%1150,50+randi()%660)
		$RNA_nodes.add_child(rna_obj)
	
	# Spawn green food
	for _i in range(6 + randi()%4):
		var plant = load("res://Scenes/Food_object.tscn").instance()
		plant.position = Vector2(100+randi()%1150,50+randi()%660)
		$Plant_nodes.add_child(plant)
		
	var traits = Global.get_traits()
	var has_sight = traits.has(Global.Trait.Sight)
	update_vision_radius(NORMAL_SIGHT_MULTIPLIER if has_sight else SHORT_SIGHT_MULTIPLIER)
	update_fog($Player.position)
	
	start_sun_event()
	
func update_genome():
	$HUD.refresh()
	if Global.get_traits().has(Global.Trait.Photosensivity):
		$Sun.energy = 2.5
	else:
		$Sun.energy = 1
	
func update_vision_radius(new_radius):
	lightImage.resize(lightImage.get_width()*new_radius, lightImage.get_height()*new_radius)
	light_offset = Vector2(LightTexture.get_width()/2*new_radius, LightTexture.get_height()/2*new_radius)

func update_fog(new_grid_position):
	var traits = Global.get_traits()
	var has_long_sight = traits.has(Global.Trait.Long_Vision)
	fog.visible = not has_long_sight
	if has_long_sight:
		return
	fogImage.lock()
	lightImage.lock()
	
	fogImage.fill(Color.black)
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))
	fogImage.blend_rect(lightImage, light_rect, new_grid_position - light_offset)

	fogImage.unlock()
	lightImage.unlock()
	update_fog_image_texture()

func update_fog_image_texture():
	fogTexture.create_from_image(fogImage)
	fog.texture = fogTexture

func _physics_process(delta):
	if paused:
		return
	
	# Only updates the flag, if the player has moved
	if $Player.position != player_position:
		if $Player.position.distance_to(player_position) > 0.1:
			update_fog($Player.position)
		player_position = $Player.position
		
	#Sun event
	if sun_event_in_progress:
		$Sun.position = sun_start_pos + (sun_end_pos - sun_start_pos) * \
						((current_time - sun_event_start_time) / sun_duration)
		var sun_dist = $Sun.position.distance_to($Player.position)
		
		if sun_dist<1050:
			Global.hydration -= delta*sun_heavy_dry * $Sun.energy
		elif sun_dist<1550:
			Global.hydration -= delta*sun_light_dry * $Sun.energy
			
		if current_time - sun_event_start_time >= sun_duration:
			sun_event_in_progress = false
		
	if Global.hydration <= 0 or Global.energy <= 0:
		$Player.die()
		$HUD.die()
		die()
		
	current_time += delta


func die():
	pause()
	$LabelDied.visible = true
	
func pause():
	paused = true
	
func unpause():
	paused = false

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

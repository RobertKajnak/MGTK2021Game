extends Node2D

var message_fade_counter = 0
var message_fade_level = 0
var message_color = Color(1,1,1,0)
var current_time = 0
var hp_tick = 0

var paused:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.reset_stats(1)
	$Button/Mob1.playing = true;
	$HUD/LabelHelp.set_bbcode(Data.help_string_lvl1)
	
	refresh_HUD()
	

func refresh_HUD():
	$HUD/ContainerStats/ContainerHP/LabelHPValue.text = str(Global.HP)
	$HUD/ContainerStats/ContainerHP/LabelScoreValue.text = str(Global.Score)
	
	
func print_info(message):
	message_color = Color(1,1,1,1)
	_message_set_text(message)
	
func print_error(message):
	message_color = Color(1,0,0,1)
	_message_set_text(message)

func _message_set_text(message):
	print(message)
	message_fade_level = 0
	message_fade_counter = 0
	$HUD/LabelMessage.set_text(message)

func toggle_pause():
	if paused:
		unpause()
	else:
		pause()

func unpause(silent = false):
	if not silent:
		print_info('Game Unpaused')
	paused = false

func pause(silent = false):
	if not silent:
		print_info('Game Paused')
	paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Notification
	if message_fade_level<1:
		message_fade_counter += delta
		message_fade_level = exp(message_fade_counter)/30
		message_color.a = 1-message_fade_level
		$HUD/LabelMessage.set_modulate(message_color)
	else:
		message_fade_counter = 0
		
		
	if not paused:
		current_time += delta
		hp_tick +=delta
		
		if hp_tick>=0.3:
			hp_tick -= 0.3
			Global.HP -= 5
			refresh_HUD()
		
		if Global.HP <=0:
			print_error('You Died')
			pause(true)

func exit():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
#%% Input handling
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_P:
				toggle_pause()
			if event.scancode == KEY_H:
				$HUD/LabelHelp.visible = !$HUD/LabelHelp.visible
				if $HUD/LabelHelp.visible:
					pause()
				else:
					unpause()
			if event.scancode == KEY_ESCAPE:
				exit()
				
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# For Windows, if 'x' is clicked, alt-f4 etc.
		pass
	elif what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		# For android
		exit()
		
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN or what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		pause()
		pass


func _on_Button_pressed():
	if not paused:
		Global.Score += 100
		refresh_HUD()

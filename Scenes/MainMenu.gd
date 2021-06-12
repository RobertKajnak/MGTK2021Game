extends Control

func _ready():
	# TODO remove this before launch
	get_tree().change_scene("res://Scenes/Level2.tscn") 
	pass

func _on_ButtonStart_pressed():
	get_tree().change_scene("res://Scenes/Level2.tscn")

func _on_ButtonExit_pressed():
	exit_game()

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
		exit_game()
	elif what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		exit_game()
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN or what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		pass

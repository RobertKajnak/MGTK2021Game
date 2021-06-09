extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonStart_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_ButtonOptions_pressed():
	pass # Replace with function body.


func _on_ButtonExit_pressed():
	exit_game()

func exit_game():
	get_tree().quit()

#%% Input handling
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

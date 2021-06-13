extends Control

var counter = 1
var tut_pressed = false

func _ready():
	#var _err = get_tree().change_scene("res://Scenes/Level2.tscn")
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("mouse") and tut_pressed:
		match counter:
			1:
				$Tut2.visible = true
				$Tut1.visible = false
			2:
				$Tut3.visible = true
				$Tut2.visible = false
			3:
				$Tut4.visible = true
				$Tut3.visible = false
			4:
				$Tut5.visible = true
				$Tut4.visible = false
			5:
				$Tut6.visible = true
				$Tut5.visible = false
			6:
				$Tut7.visible = true
				$Tut6.visible = false
			7:
				$Tut8.visible = true
				$Tut7.visible = false
			8:
				$Tut8.visible = false
				$CenterContainer/VBoxContainer/ButtonExit.disabled = false
				$CenterContainer/VBoxContainer/ButtonTutorial.disabled = false
				$CenterContainer/VBoxContainer/ButtonStart.disabled = false
				counter = 0
				tut_pressed = false
		counter += 1

func _on_ButtonStart_pressed():
	var _err = get_tree().change_scene("res://Scenes/Level2.tscn")

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


func _on_ButtonTutorial_pressed():
	$Tut1.visible = true
	tut_pressed = true
	$CenterContainer/VBoxContainer/ButtonExit.disabled = true
	$CenterContainer/VBoxContainer/ButtonTutorial.disabled = true
	$CenterContainer/VBoxContainer/ButtonStart.disabled = true

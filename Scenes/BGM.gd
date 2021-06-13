extends AudioStreamPlayer

var mute = false


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_M:
				mute()
				
func mute():
	if mute:
		self.play()
		mute = false
	else:
		self.stop()
		mute = true
				# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

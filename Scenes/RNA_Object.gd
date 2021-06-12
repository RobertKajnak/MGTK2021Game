extends Area2D

var letter
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	letter = Global.letters_possible[randi() % len(Global.letters_possible)]
	$Sprite.set_modulate(Global.letter_to_color[letter])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

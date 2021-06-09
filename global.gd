extends Node


var current_level = 1
var HP = 100
var Score = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reset_stats(level:int):
	if level == 1:
		HP = 100
		Score = 0

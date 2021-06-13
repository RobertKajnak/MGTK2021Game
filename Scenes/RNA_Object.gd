extends Area2D

var letter

var coll_obj
var coll_func

func _ready():
	letter = Global.letters_possible[randi() % len(Global.letters_possible)]
	$Sprite.set_modulate(Global.letter_to_color[letter])
	$Letter_Label.text = letter

func set_collision_callback(object, function):
	self.coll_obj = object
	self.coll_func = function

func _on_RNA_body_entered(body):
	Global.add_gene(letter)
	coll_obj.call(coll_func)
	queue_free()

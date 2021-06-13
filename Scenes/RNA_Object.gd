extends Area2D

var letter

func _ready():
	letter = Global.letters_possible[randi() % len(Global.letters_possible)]
	$Sprite.set_modulate(Global.letter_to_color[letter])
	$Letter_Label.text = letter

func _on_RNA_body_entered(body):
	Global.hud_object.playEffect("DNA.wav")
	Global.add_gene(letter)
	queue_free()

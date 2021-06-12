extends Area2D

var letter

func _ready():
	letter = Global.letters_possible[randi() % len(Global.letters_possible)]
	$Sprite.set_modulate(Global.letter_to_color[letter])

func _on_RNA_body_entered(body):
	Global.genome += letter
	get_hub().refresh()
	queue_free()

func get_hub():
	# Gyuri: nem a legjobb, mert ha megvaltozik az objektumok hierarhiaja 
	# akkor ez nem mukszik tobbet!
	return get_parent().get_parent().get_child(Global.hud_index)

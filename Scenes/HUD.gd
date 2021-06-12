extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func refresh():
	var genes = $ContainerDNA.get_children()
	var genome = ""
	for gene in genes:
		genome += gene.get_letters()
		
	if genome != Global.genome:
		Global.clear_children($ContainerDNA)
		var accumulator = ""
		for dna_letter in Global.genome:
			if len(accumulator)<3:
				accumulator += dna_letter
			else:
				generate_dna_segment(accumulator)
				accumulator = dna_letter
		if len(accumulator)>0:
			generate_dna_segment(accumulator)
			
			
		
func generate_dna_segment(segment):
	var dna_segment = load("res://Scenes/DNA_Segment.tscn").instance()
	$ContainerDNA.add_child(dna_segment)
	dna_segment.set_letters(segment)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

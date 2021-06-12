extends CanvasLayer

func _ready():
	Global.hud_index = get_index()

func refresh():
	var genes = $ContainerDNA.get_children()
	var genome = ""
	for gene in genes:
		genome += gene.get_letters()
		
	if genome != Global.genome:
		Global.clear_children($ContainerDNA)
		var accumulator = ""
		for dna_letter in Global.genome:
			if len(accumulator) < 3:
				accumulator += dna_letter
			else:
				generate_dna_segment(accumulator)
				accumulator = dna_letter
		if len(accumulator) > 0:
			generate_dna_segment(accumulator)
		
func generate_dna_segment(segment):
	var dna_segment = load("res://Scenes/DNA_Segment.tscn").instance()
	$ContainerDNA.add_child(dna_segment)
	dna_segment.set_letters(segment)

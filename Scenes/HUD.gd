extends CanvasLayer

func _ready():
	Global.hud_object = self

func _process(_delta) -> void:
	$Energy.value = Global.energy
	$Hydration.value = Global.hydration

func refresh() -> void:
	var genome = ""
	for gene in $ContainerDNA.get_children():
		genome += gene.get_letters()
		
	if genome != Global.genome:
		Global.clear_children($ContainerDNA)
		var genes = Global.sliding_window_of(3, Global.genome)
		for gene_index in range(len(genes)):
			var gene = genes[gene_index]
			generate_dna_segment(Global.array_to_string(gene), gene_index)
		
func generate_dna_segment(gene: String, gene_index: int) -> void:
	var dna_segment = load("res://Scenes/DNA_Segment.tscn").instance()
	$ContainerDNA.add_child(dna_segment)
	dna_segment.set_segment(gene, gene_index)
	
	if len(gene) == len(Global.letters_possible) and not Global.discovered_traits.has(gene):
		Global.discovered_traits.append(gene)
		$ScrollContainer/KnownTraitContainer.add_trait(gene)
		

func die() -> void:
	$Energy.set_modulate(Color.darkgray)
	$Hydration.set_modulate(Color.darkgray)
	$ContainerDNA.set_modulate(Color.darkgray)
	$LabelDied.visible = true

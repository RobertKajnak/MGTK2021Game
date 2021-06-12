extends Node

var hud_index := 0 # Used to update the HUD during collisions

var current_level := 1

# Player stuff
var HP := 100
var Score := 0
var genome := ""

var letters_possible = ['A', 'T', 'G']
var letter_to_color = { 'A': Color.red, 'T': Color.green, 'G': Color.yellow }

enum Trait { 
	Movement, Speed, Absorption, Photosynthesis, Digestion, Water_Survival, 
	Sight, Long_Vision, Sense_Cells, Poo_Eating, Virus, Water_Storage, 
	Better_Core, Double_Core, Combustion, Nothing, Inverse_Movement, 
	Unstable_DNA, Giant, Color_Change, Chameleon, Halucination, 
	Photosensibility, Jump
	}

func trait_to_text(trait):
	match trait:
		Trait.Movement: return "Movement"
		Trait.Speed: return "Speed"
		Trait.Absorption: return "Absorption"
		Trait.Photosynthesis: return "Photosynthesis" 
		Trait.Digestion: return "Digestion" 
		Trait.Water_Survival: return "Water Survival" 
		Trait.Sight: return "Sight" 
		Trait.Long_Vision: return "Long Vision" 
		Trait.Sense_Cells: return "Sense Cells" 
		Trait.Poo_Eating: return "Poo Eating" 
		Trait.Virus: return "Virus" 
		Trait.Water_Storage: return "Water Storage" 
		Trait.Better_Core: return "Better Core" 
		Trait.Double_Core: return "Double Core" 
		Trait.Combustion: return "Combustion" 
		Trait.Nothing: return "Nothing" 
		Trait.Inverse_Movement: return "Inverse Movement" 
		Trait.Unstable_DNA: return "Unstable DNA" 
		Trait.Giant: return "Giant" 
		Trait.Color_Change: return "Color Change" 
		Trait.Chameleon: return "Chameleon" 
		Trait.Halucination: return "Halucination" 
		Trait.Photosensibility: return "Photosensibility" 
		Trait.Jump: return "Jump"

var index_to_trait_and_color = [
[Trait.Movement ,Color.orange],
[Trait.Speed, Color.orange],
[Trait.Absorption, Color.white],
[Trait.Photosynthesis, Color.green],
[Trait.Digestion, Color.aquamarine],
[Trait.Water_Survival, Color.aqua],
[Trait.Sight, Color.blue],
[Trait.Long_Vision, Color.blue],
[Trait.Sense_Cells, Color.blue],
[Trait.Poo_Eating, Color.aquamarine],
[Trait.Virus, Color.red],
[Trait.Water_Storage, Color.aqua],
[Trait.Better_Core, Color.black],
[Trait.Double_Core, Color.black],
[Trait.Combustion, Color.red],
[Trait.Nothing, Color.gray],
[Trait.Nothing, Color.gray],
[Trait.Nothing, Color.gray],
[Trait.Nothing, Color.gray],
[Trait.Inverse_Movement, Color.orange],
[Trait.Unstable_DNA, Color.red],
[Trait.Giant, Color.gray],
[Trait.Color_Change, Color.gray],
[Trait.Chameleon, Color.gray],
[Trait.Halucination, Color.blue],
[Trait.Photosensibility, Color.red],
[Trait.Jump, Color.orange]]

var index_to_trait = []
var index_to_gene = []
var index_to_color = []
var gene_to_index = {}

func _ready():
	var sc = len(letters_possible)
	for i in range(len(index_to_trait_and_color)):
		var combo = letters_possible[i/sc/sc%sc] + letters_possible[i/sc%sc] + letters_possible[i%sc]
		index_to_gene.append(combo)
		gene_to_index[combo] = i
		index_to_color.append(index_to_trait_and_color[i][1])
		index_to_trait.append(index_to_trait_and_color[i][0])

func reset_stats(level:int):
	if level == 1:
		HP = 100
		Score = 0
		
func clear_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# Add a gene to the player genome
func add_gene(letter):
	var max_groups = 4
	var max_letters = max_groups * len(letters_possible)
	genome += letter
	var start_index = max(0, len(genome) - max_letters)
	genome = genome.substr(start_index, len(genome))

# Returns a list of active traits the player has
func get_traits():
	var traits = []
	for letters in sliding_window_of(3, genome):
		var gene = array_to_string(letters)
		if len(gene) == 3:
			traits.append(index_to_trait[gene_to_index[gene]])
	return traits

# Example: sliding_window_of(2, "ASDFG") == [[A, S], [D, F], [G]]
func sliding_window_of(n: int, array):
	var result = []
	var temp = []
	for element in array:
		temp.append(element)
		if len(temp) == 3:
			result.append(temp)
			temp = []
	result.append(temp)
	return result
	
func array_to_string(array: Array):
	var result = ""
	for element in array:
		result += element
	return result

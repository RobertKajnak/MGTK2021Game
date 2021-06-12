extends Node

var hud_index := 0 # Used to update the HUD during collisions

var current_level := 1

# Player stuff
var energy := 50
var hydration := 50
var genome := ""

var letters_possible = ['A', 'T', 'G']
var letter_to_color = { 'A': Color.red, 'T': Color.green, 'G': Color.yellow }

enum Trait { 
	Movement, Speed, Absorption, Photosynthesis, Digestion, Water_Survival, 
	Sight, Long_Vision, Sense_Cells, Poo_Eating, Virus, Water_Storage, 
	Better_Core, Double_Core, Combustion, Nothing1, Nothing2, Nothing3, 
	Nothing4, Inverse_Movement, Unstable_DNA, Giant, Color_Change, Chameleon, 
	Halucination, Photosensibility, Jump
	}

func trait_to_text(trait: int):
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
		Trait.Nothing1: return "Nothing" 
		Trait.Nothing2: return "Nothing" 
		Trait.Nothing3: return "Nothing" 
		Trait.Nothing4: return "Nothing" 
		Trait.Inverse_Movement: return "Inverse Movement" 
		Trait.Unstable_DNA: return "Unstable DNA" 
		Trait.Giant: return "Giant" 
		Trait.Color_Change: return "Color Change" 
		Trait.Chameleon: return "Chameleon" 
		Trait.Halucination: return "Halucination" 
		Trait.Photosensibility: return "Photosensibility" 
		Trait.Jump: return "Jump"

func trait_to_color(trait: int): 
	match trait:
		Trait.Movement: return Color.orange
		Trait.Speed: return Color.orange
		Trait.Absorption: return Color.white
		Trait.Photosynthesis: return Color.green
		Trait.Digestion: return Color.aquamarine
		Trait.Water_Survival: return Color.aqua
		Trait.Sight: return Color.blue
		Trait.Long_Vision: return Color.blue
		Trait.Sense_Cells: return Color.blue
		Trait.Poo_Eating: return Color.aquamarine
		Trait.Virus: return Color.red
		Trait.Water_Storage: return Color.aqua
		Trait.Better_Core: return Color.black
		Trait.Double_Core: return Color.black
		Trait.Combustion: return Color.red
		Trait.Nothing1: return Color.gray
		Trait.Nothing2: return Color.gray
		Trait.Nothing3: return Color.gray
		Trait.Nothing4: return Color.gray
		Trait.Inverse_Movement: return Color.orange
		Trait.Unstable_DNA: return Color.red
		Trait.Giant: return Color.gray
		Trait.Color_Change: return Color.gray
		Trait.Chameleon: return Color.gray
		Trait.Halucination: return Color.blue
		Trait.Photosensibility: return Color.red
		Trait.Jump: return Color.orange
		
var trait_to_gene = []
var gene_to_trait = {}

func _ready():
	var sc = len(letters_possible)
	
	for i in range(Trait.size()):
		var combo = \
			letters_possible[i/sc/sc%sc] + \
			letters_possible[i/sc%sc] + \
			letters_possible[i%sc]
		trait_to_gene.append(combo)
		gene_to_trait[combo] = i
		
func clear_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

# Add a gene to the player genome
func add_gene(letter):
	var max_groups = 5
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
			traits.append(gene_to_trait[gene])
	return traits

# --- Utility Functions ---

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

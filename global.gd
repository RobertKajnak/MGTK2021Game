extends Node

var hud_object = null

var current_level := 1

# Player stuff
var energy := 5000
var hydration := 5000
var genome := ""
var DNACount := 0
var in_water := int(0)

var letters_possible = ['A', 'T', 'G']
var letter_to_color = { 'A': Color.red, 'T': Color.green, 'G': Color.yellow }

var discovered_traits = []

enum Trait { 
	Movement, Speed, Absorption, Photosynthesis, Digestion, Water_Survival, 
	Sight, Long_Vision, Sense_Cells, Poo_Eating, Virus, Water_Storage, 
	Better_Core, Nothing6, Nothing5, Nothing1, Nothing2, Nothing3, 
	Nothing4, Inverse_Movement, Nothing7, Giant, Color_Change, Chameleon, 
	Nothing8, Photosensivity, Jump
	}

func trait_to_text(trait: int):
	match trait:
		Trait.Movement: return "Movement"
		Trait.Speed: return "Speed"
		Trait.Absorption: return "Absorption"
		Trait.Photosynthesis: return "Photosynthesis" 
		Trait.Digestion: return "Digestion" 
		Trait.Water_Survival: return "Hydrophilia" 
		Trait.Sight: return "Sight" 
		Trait.Long_Vision: return "Long Vision" 
		Trait.Sense_Cells: return "Sense Cells" 
		Trait.Poo_Eating: return "Meat eating" 
		Trait.Virus: return "Virus" 
		Trait.Water_Storage: return "Water Storage" 
		Trait.Better_Core: return "Better Core" 
		Trait.Nothing7: return "Nothing" 
		Trait.Nothing5: return "Nothing" 
		Trait.Nothing1: return "Nothing" 
		Trait.Nothing2: return "Nothing" 
		Trait.Nothing3: return "Nothing" 
		Trait.Nothing4: return "Nothing" 
		Trait.Inverse_Movement: return "Backwards" 
		Trait.Nothing8: return "Nothing" 
		Trait.Giant: return "Giant" 
		Trait.Color_Change: return "Color Change" 
		Trait.Chameleon: return "Chameleon" 
		Trait.Nothing6: return "Nothing" 
		Trait.Photosensivity: return "Photosensivity" 
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
		Trait.Better_Core: return Color.burlywood
		Trait.Nothing7: return Color.gray
		Trait.Nothing5: return Color.gray
		Trait.Nothing1: return Color.gray
		Trait.Nothing2: return Color.gray
		Trait.Nothing3: return Color.gray
		Trait.Nothing4: return Color.gray
		Trait.Inverse_Movement: return Color.orange
		Trait.Nothing8: return Color.gray
		Trait.Giant: return Color.gray
		Trait.Color_Change: return Color.gray
		Trait.Chameleon: return Color.gray
		Trait.Nothing6: return Color.gray
		Trait.Photosensivity: return Color.red
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
func add_gene(letter: String) -> void:
	DNACount += 1
	var max_groups = 5
	var max_letters = max_groups * len(letters_possible)
	genome += letter
	var start_index = max(0, len(genome) - max_letters)
	genome = genome.substr(start_index, len(genome))
	hud_object.refresh()
	
# Add a trait
func add_random_trait() -> void:
	DNACount += 3
	var max_groups = 5
	var max_letters = max_groups * len(letters_possible)
	if len(genome) > max_letters - 3:
		var start_index = max(0, len(genome) - max_letters + 3)		
		genome = genome.substr(start_index, len(genome))
	var trait = randi() % Trait.size()
	genome += trait_to_gene[trait]
	hud_object.refresh()

# Returns a list of active traits the player has
func get_traits() -> Array:
	var traits = []
	for letters in sliding_window_of(3, genome):
		var gene = array_to_string(letters)
		if len(gene) == 3:
			traits.append(gene_to_trait[gene])
	return traits

# Removes a number of letters from genome
func pop_letters(n: int) -> void:
	genome = genome.substr(n, len(genome))
	hud_object.refresh()
	
# --- Utility Functions ---

# Example: sliding_window_of(2, "ASDFG") == [[A, S], [D, F], [G]]
func sliding_window_of(n: int, array):
	var result = []
	var temp = []
	for element in array:
		temp.append(element)
		if len(temp) == n:
			result.append(temp)
			temp = []
	result.append(temp)
	return result
	
func array_to_string(array: Array):
	var result = ""
	for element in array:
		result += element
	return result

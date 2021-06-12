extends Node


var current_level = 1
var HP = 100
var Score = 0;
var genome = ""

var letters_possible = ['A', 'T', 'G']
var letter_to_color = {'A':Color.red,
						'T': Color.green,
						'G': Color.yellow}

var index_to_property_and_color = [
["Movement",Color.orange],
["Speed",Color.orange],
["Absorbtion",Color.white],
["Photosynthesis",Color.green],
["Digestion",Color.aquamarine],
["Water survival",Color.aqua],
["Sight",Color.blue],
["Long vision",Color.blue],
["Sense cells",Color.blue],
["Poo eating",Color.aquamarine],
["Virus",Color.red],
["Water storage",Color.aqua],
["Better core",Color.black],
["Double core",Color.black],
["Combustion",Color.red],
["Nothing",Color.gray],
["Nothing",Color.gray],
["Nothing",Color.gray],
["Nothing",Color.gray],
["Inverse movement",Color.orange],
["Unstable DNA",Color.red],
["Giant",Color.gray],
["Color change",Color.gray],
["Chameleon",Color.gray],
["Halucination",Color.blue],
["Photosensibility",Color.red],
["Jump",Color.orange]]

var index_to_property = []
var index_to_gene = []
var index_to_color = []
var gene_to_index = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var sc = len(letters_possible)
	for i in range(len(index_to_property_and_color)):
		var combo = letters_possible[i/sc/sc%sc] + letters_possible[i/sc%sc] + letters_possible[i%sc]
		index_to_gene.append(combo)
		gene_to_index[combo] = i
		index_to_color.append(index_to_property_and_color[i][1])
		index_to_property.append(index_to_property_and_color[i][0])

func reset_stats(level:int):
	if level == 1:
		HP = 100
		Score = 0


func clear_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_trait(gene):
	var trait_elem = load("res://Scenes/KnowTrait_HUD.tscn").instance()
	$ScrollContainer/TraitList.add_child(trait_elem)
	trait_elem.set_trait(gene)

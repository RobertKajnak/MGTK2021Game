extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_trait(gene):
	$LabelGene.set_text(gene)
	$LabelTrait.set_text(Global.trait_to_text(Global.gene_to_trait[gene]))
	$LabelTrait.set_modulate(Global.trait_to_color(Global.gene_to_trait[gene]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

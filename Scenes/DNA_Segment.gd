extends VBoxContainer


var letters setget set_letters, get_letters

func set_letters(letters:String):
	for i in range(len(letters)):
		$LetterContainer.find_node('Letter'+str(i+1)).set_text(letters[i])
		$LetterContainer.find_node('Letter'+str(i+1)).visible = true
	for i in range(len(letters),3):
		$LetterContainer.find_node('Letter'+str(i+1)).set_text("")
		$LetterContainer.find_node('Letter'+str(i+1)).visible = false
		
	if len(letters) == 3:
		var trait = Global.gene_to_trait[letters]
		var color = Global.trait_to_color(trait)
		$DNAProperty.set_text(Global.trait_to_text(trait))
		$DNAIcon.set_modulate(color)
		$DNAProperty.set_modulate(color)
		
		$DNAProperty.visible = true
		$DNAIcon.visible = true
	else:
		$DNAProperty.visible = false
		$DNAIcon.visible = false
		
func get_letters():
	return $LetterContainer/Letter1.text + $LetterContainer/Letter2.text +\
		$LetterContainer/Letter3.text

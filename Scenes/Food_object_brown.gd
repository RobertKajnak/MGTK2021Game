extends Area2D

func _ready():
	pass

func _on_Brown_body_entered(body):
	var traits = Global.get_traits()
	var can_eat = traits.has(Global.Trait.Digestion)
	if can_eat and Global.energy < 5000:
		Global.energy = min(5000, Global.energy + 100)
		queue_free()

extends Area2D

func _on_Cell_body_entered(body):
	var traits = Global.get_traits()
	var can_eat = traits.has(Global.Trait.Digestion)
	if can_eat and Global.energy < 5000:
		Global.hud_object.playEffect()
		Global.energy = min(5000, Global.energy + 1000)		
		Global.add_random_trait()
		queue_free()

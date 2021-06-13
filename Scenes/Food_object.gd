extends Area2D

func _on_Plant_body_entered(body):
	var traits = Global.get_traits()
	var can_eat = traits.has(Global.Trait.Absorption)
	if can_eat and Global.energy < 5000:
		Global.hud_object.playEffect()
		Global.energy = min(5000, Global.energy + 300)
		queue_free()

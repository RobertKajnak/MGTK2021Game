extends Area2D

func _ready():
	pass

func _on_Brown_body_entered(body):
	var traits = Global.get_traits()
	var can_eat = traits.has(Global.Trait.Poo_Eating)
	if can_eat and Global.energy < 5000:
		Global.hud_object.playEffect()
		Global.energy = min(5000, Global.energy + 500)
		queue_free()

extends Area2D

var hub

func _ready():
	hub = get_hub()

func get_hub():
	# Gyuri: nem a legjobb, mert ha megvaltozik az objektumok hierarhiaja 
	# akkor ez nem mukszik tobbet!
	return get_parent().get_parent().get_child(Global.hud_index)

func _on_Plant_body_entered(body):
	var traits = Global.get_traits()
	var can_eat = traits.has(Global.Trait.Absorption)
	if can_eat and Global.energy < 100:
		Global.energy = min(100, Global.energy + 20)
		queue_free()


extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Gain an additional 1 mp per turn for the rest of the game."
	name = "Meditate"

func effect() -> void:
	pass

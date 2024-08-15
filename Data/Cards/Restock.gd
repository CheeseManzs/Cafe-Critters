
extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Draw 2 extra cards next turn."
	name = "Restock"

func effect() -> void:
	pass

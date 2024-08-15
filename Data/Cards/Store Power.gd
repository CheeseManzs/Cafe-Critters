
extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "Gain 1 additional mp next turn."
	name = "Store Power"

func effect() -> void:
	pass

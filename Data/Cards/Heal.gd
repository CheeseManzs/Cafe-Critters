
extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Support
	description = "Heal target shelved critter for 5 HP."
	name = "Heal"

func effect() -> void:
	pass

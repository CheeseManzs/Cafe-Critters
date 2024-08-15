
extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Empower the next card played."
	name = "Caffeinate"

func effect() -> void:
	pass

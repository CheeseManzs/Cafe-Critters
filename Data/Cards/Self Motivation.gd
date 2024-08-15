
extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Take damage equal to your Attack. Empower the next card played."
	name = "Self Motivation"

func effect() -> void:
	pass

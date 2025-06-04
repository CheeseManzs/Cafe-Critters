extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Jacks [Aggro]
	role = "Basic"
	description = "Gain block equal to the amount of damage dealt to opponent faes this turn."
	name = "Cash-Out"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass

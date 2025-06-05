extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll a die. Gain (40% DEF) block. If you rolled a 6, gain 1 mp."
	name = "Functional Gambling"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass

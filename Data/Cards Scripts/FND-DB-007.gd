extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain 1 additional MP per turn for the rest of the game. "
	name = "Meditate"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.addMPPerTurn(1)

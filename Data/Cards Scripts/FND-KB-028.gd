extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "For the rest of the game, whenever this fae plays 10 skills, draw 2, gain 2 MP, and your team heals (20% Max HP) health."
	name = "insert microphone name"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Legendary

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass

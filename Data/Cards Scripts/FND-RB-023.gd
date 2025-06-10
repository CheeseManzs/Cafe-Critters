extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Gain 1 MP. Whenever an opponent fae switches in this turn, they take (10% Opponent Max HP) damage. "
	name = "Fear of Missing Out"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass

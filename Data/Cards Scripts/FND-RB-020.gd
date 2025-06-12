extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Gain 1 MP."
	name = "Warning"
	tags = ['Utility', 'Self-Target', 'Omen']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyOmen(attacker, defender)
	await attacker.addMP(1)
	
func calcBonus(attacker: BattleMonster, defender: BattleMonster, battleAI: BattleAI) -> int:
	return battleAI.STANDARD_BONUS

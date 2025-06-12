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
	await applyOmen(attacker, defender)
	await attacker.addMP(1)
	await giveStatus(defender,Status.EFFECTS.MISSING_OUT)
	pass

func calcBonus(attacker: BattleMonster, defender: BattleMonster, battleAI: BattleAI) -> int:
	return 0.1*defender.maxHP*(attacker.getMP() - defender.getMP())

extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "Reckless. Your next attack gains +100%. Gain 1 mp"
	name = "Stack The Deck"

func effect(attacker: BattleMonster, defender: BattleMonster):
	await applyReckless(attacker, defender)
	await attacker.addAttackBonus(1,true)
	await attacker.addMP(1)

extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "Reckless > 100% Attack. If Reckless, gain 2 mp and draw 2 cards. You gain +25% on Attacks this turn."
	name = "Devious Cackle"
	selfTarget = true

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false


func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	
	await attacker.addAttackBonus(0.25)
	if !(await applyReckless(attacker, defender)):
		BattleLog.singleton.log("Card does not meet requirements...")
		return 0

	attacker.addMP(2)
	attacker.drawCards(2)
	
	
	return 2

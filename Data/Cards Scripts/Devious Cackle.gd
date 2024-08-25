extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = ROLE.Unique
	description = "Reckless > 100% Attack. If Reckless, gain 2 mp and draw 2 cards. You gain +25% on Attacks this turn."
	name = "Devious Cackle"

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false


func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#create status object
	var attackPower = 0
	await EffectFlair.singleton._runFlair("Recklesss")
	var discardedCard = await attacker.discardRandomCard()
	if discardedCard == null || !meetsRequirement(discardedCard, attacker, defender):
		BattleLog.singleton.log("Card does not meet requirements...")
		return 0

	attacker.addMP(2)
	attacker.drawCards(2)
	attacker.addAttackBonus(0.25)
	
	return 2

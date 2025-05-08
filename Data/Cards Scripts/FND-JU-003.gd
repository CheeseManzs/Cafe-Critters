extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "If you were Reckless this turn, draw 2 cards. Attack 25%."
	name = "Non-Pointy End"
	power = 0.25

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.RECKLESS):
		return true
	else:
		return false

func effect(attacker: BattleMonster, defender: BattleMonster):
	#calc attack power
	await dealDamage(attacker, defender, power)
	
	if !attacker.hasStatus(Status.EFFECTS.RECKLESS):
		BattleLog.singleton.log(attacker.rawData.name + " was not Reckless this turn...")
		return

	
	#add cards
	attacker.drawCards(2)

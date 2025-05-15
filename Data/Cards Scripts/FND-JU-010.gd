extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "Reckless > 100% Attack. If Reckless, Strongarm. 200% Attack."
	name = "Blackjack Beatdown"
	power = 2

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false

func effect(attacker: BattleMonster, defender: BattleMonster):
	#calc attack power
	await dealDamage(attacker, defender)
	
	if !(await applyReckless(attacker, defender)):
		BattleLog.singleton.log("Card does not meet requirements...")
		return 0

	await giveStatus_noempower(defender, Status.EFFECTS.STRONGARM, 1)
	
	return

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.STRONGARM, 1)

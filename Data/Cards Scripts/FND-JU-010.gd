extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = ROLE.Unique
	description = "Reckless > 100% Attack. If Reckless, Strongarm. Attack 200%."
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

	await attacker.addStatusCondition(Status.new(Status.EFFECTS.STRONGARM),true)
	
	return

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.STRONGARM)
